#!/usr/bin/env ruby
#
# gethourdata_of_qinhuangdao.rb
# Copyright (C) 2016 libaoxi <693879111@qq.com>
#
# Distributed under terms of the MIT license.
#

module Qinhuangdao
	class Qinhuangdao
		def request
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
					linedata=MonitorPointHour.find_or_create_by(point_id: m.id,data_real_time: l['DataTime'].to_time)
					# next if linedata.AQI
					tmp=Hash.new
					l['Polls']['Poll'].each do |p|
						tmp[p['Name']]=p['Value'].to_f*1000
					end
					linedata.AQI = l['AQI']
					linedata.SO2 = tmp['SO2']
					linedata.NO2 = tmp['NO2']
					linedata.CO = tmp['CO']
					linedata.pm10 = tmp['PM10']
					linedata.pm25 = tmp['PM2.5']
					linedata.O3 = tmp['O3']
					linedata.O3_8h = tmp['O3-8h']
					linedata.level = l['Level']
					linedata.main_pol = l['MaxPoll']
					linedata.save
					puts Time.now.to_s+' '+l['Name']+' Save OK!'
				end
			end
		end
	end
end
Qinhuangdao::Qinhuangdao.new.request
