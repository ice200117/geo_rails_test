#!/usr/bin/env ruby
#
# gethourdata_of_qinhuangdao.rb
# Copyright (C) 2016 libaoxi <693879111@qq.com>
#
# Distributed under terms of the MIT license.
#

module Qinhuangdao
	class Qinhuangdao
		def hour
			data = Hash.new
			begin
				response = HTTParty.get('http://121.28.49.85:8080/datas/hour/130000.xml')
				data = Hash.from_xml(response.body)
			rescue
				return nil
			end
			a=data['Result']['Citys']['City']
			a.each do |t|
				next if t['Name']!='秦皇岛市'
				puts t['Name']
				t['Pointers'].values[0].each do |l|
					pointname=l['Name']
					len=pointname.length
					pointname=pointname[0,len-3] if pointname[len-3,3]=='(*)'
					m=City.find_by_city_name(l['City']).monitor_points.find_by_pointname(pointname)
					if MonitorPointHour.where("monitor_point_id = ? AND data_real_time >= ? AND data_real_time <=?",m.id,l['DataTime'].to_time.beginning_of_hour,l['DataTime'].to_time.end_of_hour).length==0
						linedata=MonitorPointHour.new
						# next if linedata.AQI
						linedata.monitor_point_id=m.id
						linedata.data_real_time=l['DataTime'].to_time.utc
						linedata.AQI = l['AQI']
						linedata.SO2 = tmp['SO2'].to_f*1000
						linedata.NO2 = tmp['NO2'].to_f*1000
						linedata.CO = tmp['CO']
						linedata.pm10 = tmp['PM10'].to_f*1000
						linedata.pm25 = tmp['PM2.5'].to_f*1000
						linedata.O3 = tmp['O3'].to_f*1000
						linedata.O3_8h = tmp['O3-8h'].to_f*1000
						linedata.quality = l['Level']
						linedata.main_pol = l['MaxPoll']
						linedata.city_id = 11
						linedata.save
						puts Time.now.to_s+' '+l['Name']+' Save OK!'
					end
				end
			end
		end

		def day
			data = Hash.new
			begin
				response = HTTParty.get('http://121.28.49.85:8080/datas/day/130000.xml')
				data = Hash.from_xml(response.body)
			rescue
				return nil
			end
			a=data['Result']['Citys']['City']
			a.each do |t|
				next if t['Name']!='秦皇岛市'
				puts t['Name']
				t['Pointers']['Pointer'].each do |l|
					pointname=l['Name']
					len=pointname.length
					pointname=pointname[0,len-3] if pointname[len-3,3]=='(*)'
					m=City.find_by_city_name(t['Name']).monitor_points.find_by_pointname(pointname)
					linedata=Hash.new
					tmp=someday_data('day',l['DataTime'].to_time,MonitorPoint.find_by_pointname(pointname).id)
					linedata=tmp if !tmp.nil?
					linedata['id']=m.id
					linedata['time']=l['DataTime'].to_time
					linedata['aqi'] = l['AQI']
					linedata['quality'] = l['Level']
					linedata['level'] = l['LevelIndex']
					linedata['main_pol'] = l['MaxPoll']
					linedata['city_id'] = 11
					MonitorPointDay.new.save_with_arg(linedata)
				end
			end
		end

		def month
			mp=MonitorPoint.where("city_id = 11")
			# byebug
			mp.each do |l|
				line = nil
				tmp = someday_data('month',Time.now.yesterday,l.id)
				line=tmp if !tmp.nil?
				line['monitor_point_id'] = l.id
				line['data_real_time'] = Time.now.yesterday
				MonitorPointMonth.new.save_with_arg(line)
			end
		end

		def year
			mp=MonitorPoint.where("city_id = 11")
			mp.each do |l|
				line = nil
				tmp = someday_data('year',Time.now.yesterday,l.id)
				line=tmp if !tmp.nil?
				line['monitor_point_id'] = l.id
				line['data_real_time'] = Time.now.yesterday
				MonitorPointYear.new.save_with_arg(line)
			end
		end

		def history_month
			mp=MonitorPoint.find_by_city_id(11)
			mp.each do |l|
				line = nil
				stime = '20150501'.to_time
				etime = Time.now.yesterday.end_of_day
				while stime<etime
					tmp = someday_data('year',stimey,l.id)
					line=tmp if !tmp.nil?
					line['monitor_point_id'] = l.id
					line['data_real_time'] = stime
					stime+=3600*24
				end
			end
		end

		def history_year
			mp=MonitorPoint.find_by_city_id(11)
			mp.each do |l|
				line = nil
				stime = '20150501'.to_time
				etime = Time.now.yesterday.end_of_day
				while stime<etime
					tmp = someday_data('year',stimey,l.id)
					line=tmp if !tmp.nil?
					line['monitor_point_id'] = l.id
					line['data_real_time'] = stime
					stime+=3600*24
				end
			end
		end
		#计算某天的数据
		def someday_data(flag,time,id)
			so2=Array.new
			no2=Array.new
			o3=Array.new
			co=Array.new
			pm10=Array.new
			pm25=Array.new
			temp=nil
			if flag == 'day'
				temp=MonitorPointHour.where("monitor_point_id = ? AND data_real_time >= ? AND data_real_time <=?",id,time.beginning_of_day,time.end_of_day)
			elsif flag =='month'
				temp=MonitorPointDay.where("monitor_point_id = ? AND data_real_time >= ? AND data_real_time <=?",id,time.beginning_of_month,time.end_of_day)
			elsif flag =='year'
				temp=MonitorPointDay.where("monitor_point_id = ? AND data_real_time >= ? AND data_real_time <=?",id,time.beginning_of_year,time.end_of_day)
			end
			return nil if temp.length==0
			temp.each do |t|
				so2<<t.SO2 if !t.SO2.nil?
				no2<<t.NO2 if !t.NO2.nil?
				if flag=='day'
					o3<<t.O3_8h if !t.O3.nil?
				else
					o3<<t.O3 if !t.O3.nil?
				end
				co<<t.CO if !t.CO.nil?
				pm10<<t.pm10 if !t.pm10.nil?
				pm25<<t.pm25 if !t.pm25.nil?
			end
			mpd=Hash.new
			mpd['so2']=avg(so2)
			mpd['no2']=avg(no2)
			if flag=='day'
				mpd['o3']=avg(o3)
				mpd['co']=avg(co)
			else
				mpd['o3']=percentile(o3,0.9)
				mpd['co']=percentile(co,0.95)
			end
			mpd['pm10']=avg(pm10)
			mpd['pm25']=avg(pm25)
			mpd
		end

		#真气网的小时数据
		def history_hour
			mp=MonitorPoint.where("city_id=11")
			nameid=Hash.new
			mp.each do |t|
				nameid[t.pointname] = t.id
			end
			stime="20150501".to_time
			etime=Time.now
			while stime<etime
				data=request_zq("HOUR",stime)
				stime+=60*60
				if data['total']==0
					puts stime.to_s+' total=0' 
					next
				end
				tmp = Hash.new
				tmp['time'] = data['time'].to_time
				data=data['rows']
				data.each do |l|
					tmp['id']=nameid[l['pointname']]
					tmp['aqi']=l['aqi']
					tmp['pm25']=l['pm2_5']
					tmp['pm10']=l['pm10']
					tmp['so2']=l['so2']
					tmp['no2']=l['no2']
					tmp['o3']=l['o3']
					tmp['o3_8h']=l['o3_8h']
					tmp['co']=l['co']
					tmp['quality']=l['quality']
					tmp['main_pol']=l['main_pollutant']
					tmp['pointname'] = l['pointname']
					tmp['city_id'] = 11
					# byebug
					MonitorPointHour.new.save_with_arg(tmp)
				end
			end
		end
		def history_day
			mp=MonitorPoint.where(11)
			nameid=Hash.new
			mp.each do |t|
				nameid[t.pointname] = t.id
			end
			stime="20140101".to_time
			etime=Time.now
			while stime<etime
				tmp = Hash.new
				data=request_zq("DAY",time)
				stime+=3600
				if data['total'] == 0
					puts stime.to_s+' total=0'
					next
				end
				tmp['time']
				data=data['rows']
				data.each do |l|
					tmp['id']=nameid[l['pointname']]
					tmp['aqi']=l['aqi']
					tmp['pm25']=l['pm2_5']
					tmp['pm10']=l['pm10']
					tmp['so2']=l['so2']
					tmp['no2']=l['no2']
					tmp['o3']=l['o3']
					tmp['o3_8h']=['o3_8h']
					tmp['co']=['co']
					tmp['quality']=l['quality']
					tmp['main_pol']=l['main_pollutant']
					tmp['city_id'] = 11
					MonitorPointDay.new.save_with_arg(tmp)
				end
			end
		end

		def request_zq(typestr,timestr)
			begin
				secretstr = '5d68a3d26f2d62209cd8bf05d7dae8cd'
				methodstr = 'GETQHDHISTORYDATA'
				if typestr=="HOUR"
					timestr=timestr.strftime("%Y-%m-%d-%H")
				elsif typestr=="DAY"
					timestr=timestr.strftime("%Y-%m-%d")
				end
				option = {secret:secretstr,method:methodstr,type:typestr,time:timestr,key:Digest::MD5.hexdigest(secretstr+methodstr+typestr+timestr)}
				response = HTTParty.post('http://www.izhenqi.cn/api/palmapi.php', :body => option)
				JSON.parse(Base64.decode64(response.body))
			rescue
				puts 'error'
			end
		end

		def avg(array)
			sum=0
			array.each{|x| sum+=x}
			if array.length != 0
				sum/array.length if array.length!=0
			else
				0
			end
		end

		#百分位计算
		def percentile(array,num)
			#co o3百分位数计
			array = array.sort
			ind=array.length*num
			(ind.is_a?Float) ? array[ind.floor].to_f : (array[ind].to_f+array[ind+1].to_f)/2
		end
	end
end
