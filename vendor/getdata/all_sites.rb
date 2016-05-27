#!/usr/bin/env ruby
#
# test.rb
# Copyright (C) 2016 libaoxi <693879111@qq.com>
#
# Distributed under terms of the MIT license.
#

module AllSite
	PATH = '/vagrant/Temp/'
	# PATH = '/mnt/share/Temp/'
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

			#遍历站点数据
			@data['rows'].each do |l|
				city = City.find_by_city_name(l['city'])
				city = City.find_by_city_name(l['city']+'市') unless city
				l['city_id'] = city.id
				mp = MonitorPoint.where(pointname: l['pointname'],city_id: city.id)[0]
				l['monitor_point_id'] = mp.id
				MonitorPointHour.new.save_with_arg(l)
			end
		end
		def output_cvs
			tmpTime = Time.now.strftime("%Y%m%d%H")
			filePath = PATH+tmpTime[0..7]
			Dir::mkdir(filePath) unless Dir.exists?(filePath)
			f = File.open(filePath+tmpTime+'_station.cvs','w')
			f.puts('station_name,Lon,Lat,AQI')
			#逐条写入cvs
			f.puts(city.city_name_pinyin.to_s+','+mp.longitude.to_s+','+mp.latitude.to_s+','+l['aqi'].to_s)
			f.close #关闭
		end
	end
end
data = AllSite::Option.new
data.save
