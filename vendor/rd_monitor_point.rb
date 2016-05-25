#站点信息写入脚本
#站点信息数据：monitor_point.txt

f = File.open('/vagrant/geo_rails_qhd/test.txt','w')
IO.readlines('/vagrant/geo_rails_qhd/vendor/monitor_point.txt').each do |l|
	data = l.split(',')
	city = City.find_by_city_name(data[0])
	city = City.find_by_city_name(data[0]+'市') unless city
	if city
		if MonitorPoint.create(city_id: city.id,pointname: data[1],latitude: data[2],longitude: data[3])
			puts data.to_json+'  OK!'
		else
			f.puts(data)
		end
	else
		f.puts(data)
	end
end
f.close
