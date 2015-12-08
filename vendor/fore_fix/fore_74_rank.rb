require_relative 'city_enum.rb'

#文件操作
# path = '/mnt/share/Temp/Rank/'
path = '/vagrant/Rank/'
filename = Time.now.strftime("%Y%m%d").to_s+'.txt'
File.delete(path+filename) if File.exist?(path+filename)
f = File.new(path+filename,'w')
#遍历74城市
city_ary = Hash.new
CityEnum.china_city_74.each do |city_name|
	#获取数据库相应数据
	city = City.find_by_city_name(city_name)
	city = City.find_by_city_name(city_name[0,2]) if city.nil?
	data = city.hourly_city_forecast_air_qualities.last(120).group_by_day(&:forecast_datetime)
	byebug
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
		hs[:aqi] = tmp.inject(0){|sum,x| sum+=x}/tmp.length 
		time = city.forecast_datetime.strftime('%Y%m%d')
		if hs[time.to_sym] != nil
			city_ary[time.to_sym] << hs
		else
			city_ary[time.to_sym] = hs
		end
	end
end
byebug
#进行排名
city_ary = city_ary.sort_by{|a| a[:aqi]}
#写入廊坊市
for e in (0...city_ary.size)
	if city_ary[e][:pinyin] == 'langfangshi'
		f.puts((e+1).to_s+' '+city_ary[e][:city]+city_ary[e][:pinyin]+'AQI: '+city_ary[e][:aqi].to_s)
	end
end		
f.puts('---74city---')
#写入74城市
for e in (0...city_ary.size)
	line = (e+1).to_s+' '+city_ary[e][:city]+' '+city_ary[e][:pinyin]+' '+'AQI: '+city_ary[e][:aqi].to_s
	puts line
	f.puts(line)
end		
f.close
