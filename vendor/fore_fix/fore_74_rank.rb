require_relative 'city_enum.rb'

#文件操作
path = '/mnt/share/Temp/Rank/'
# path = '/vagrant/Rank/'
filename = Time.now.strftime("%Y%m%d").to_s+'.txt'
f = File.open(path+filename,'w')
#遍历74城市
city_ary = Hash.new
CityEnum.china_city_74.each do |city_name|
	#获取数据库相应数据
	city = City.find_by_city_name(city_name)
	city = City.find_by_city_name(city_name[0,2]) if city.nil?
	data = city.hourly_city_forecast_air_qualities.last(120).group_by_day(&:forecast_datetime)
	next if data.nil?
	puts city_name
	#对数据进行遍历，求平均值
	data.each do |line|
		tmp = Array.new
		line[1].uniq
		line[1].each do |t|
			tmp << t.AQI
		end
		hs = Hash.new
		hs[:city] = city_name
		hs[:pinyin] = city.city_name_pinyin
		hs[:aqi] = (tmp.inject(0){|sum,x| sum+=x}/tmp.length).round
		time = line[0].strftime('%Y%m%d')
		city_ary[time] = Array.new if city_ary[time] == nil
		city_ary[time] << hs
	end
end

#进行排名
city_ary.each do |k,v|
	city_ary[k] = v.sort_by{|a| a[:aqi]}
end
#写入廊坊市
city_ary.each do |k,v|
	for e in (0..v.length-1)
		e = v.length-1 - e
		if v[e][:pinyin] == 'langfangshi'
			f.puts(k+' '+v[e][:city]+' '+'AQI: '+v[e][:aqi].to_s+' '+(e+1).to_s)
		end
	end		
end
f.puts('---74city---')
#写入74城市
city_ary.each do |k,v|
	f.puts('---'+k+'---')
	for e in (0..v.length-1)
		e = v.length-1 - e
		line = k+' '+v[e][:city]+' '+v[e][:pinyin]+' AQI: '+v[e][:aqi].to_s+' RANK: '+(e+1).to_s
		f.puts(line)
	end		
end
f.close
