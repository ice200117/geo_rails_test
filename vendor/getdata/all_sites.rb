#!/usr/bin/env ruby
#
# test.rb
# Copyright (C) 2016 libaoxi <693879111@qq.com>
#
# Distributed under terms of the MIT license.
#

require_relative './city_enum.rb'

module AllSite
	# PATH = '/vagrant/Temp/'
	PATH = '/mnt/share/Temp/monitor_point_csv/'
	class Option
		def initialize 
			hs=Hash.new
			hs[:secret] = '70ad4cb02984355c0f08f2e84be72c9c'
			hs[:method] = 'GETSTATIONDATA'
			hs[:type] = 'HOUR'
			hs[:key]=Digest::MD5.hexdigest(hs[:secret]+hs[:method]+hs[:type])
			response = HTTParty.post('http://www.izhenqi.cn/api/dataapi.php', :body => hs)
			@data=JSON.parse(Base64.decode64(response.body))
		end

		def save
			#写入cvs文件
			tmpTime = Time.now.strftime("%Y%m%d%H")
			filePath = PATH+tmpTime[0..7]
			Dir::mkdir(filePath) unless Dir.exists?(filePath)
			f = File.open(filePath+'/'+tmpTime+'_station.csv','w')
			f.puts('station_name,Lon,Lat,AQI,pm2_5,pm10,so2,no2,o3,o3_8h,co,quality,main_pollutant,time,city')

			#遍历站点数据
			count = 0
			@data['rows'].each do |l|
				city = City.find_by_city_name(l['city'])
				city = City.find_by_city_name(l['city']+'市') unless city
				city = City.find_by_city_name(CityEnum.city_short(l['city'])) unless city
				if city.nil?
					puts l.to_s+' '+'City find error!'
					next
				end
				l['city_id'] = city.id
				mp = MonitorPoint.where(pointname: l['pointname'],city_id: city.id)[0]
				if mp.nil?
					next
					puts l+' '+'is nil!'
				end
				l['id'] = mp.id
				puts l
				MonitorPointHour.new.save_with_arg(l)
				count = count + 1

				# 剔除多余的邯郸错误数据，导致不能画图。
				if count >= 1534 and l['city'] == '邯郸'
				  puts l
				  next 
			    end

				#逐条写入csv
				f.puts(l['pointname']+','+mp.longitude.to_s+','+mp.latitude.to_s+','+l['aqi'].to_s+','+l['pm2_5'].to_s+','+l['pm10'].to_s+','+l['so2'].to_s+','+l['no2'].to_s+','+l['o3'].to_s+','+l['o3_8h'].to_s+','+l['co'].to_s+','+l['quality'].to_s+','+l['main_pollutant'].to_s.gsub(',','&')+','+l['time']+','+l['city'])
			end
			f.close #关闭
		end
	end
end
