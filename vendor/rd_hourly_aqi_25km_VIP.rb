#!/usr/bin/ruby
#hs = HourlyCityForecastAirQuality.all
#hs.each { |h| h.destroy }


def parse_line(line, c)
	# hc = HourlyCityForecastAirQuality.new
	sd = line[0,10]
	delta_hour = line[11,3]
	sdate = Time.local(sd[0,4],sd[4,2],sd[6,2],sd[8,2])

    hc = HourlyCityForecastAirQuality.find_or_create_by(city_id: c.id, publish_datetime: sdate, forecast_datetime: sdate+delta_hour.to_i*3600 )

	hc.AQI = line[14,4]
	hc.main_pol = line[18,13].strip
	hc.grade = line[31,1]
	hc.pm25 = line[99,6]
	hc.pm10 = line[87,6]
	hc.SO2 = line[39,6]
	hc.CO = line[63,6]
	hc.NO2 = line[51,6]
	hc.O3 = line[75,6]
	hc.VIS = line[32,7]

	hc.save

	#puts '----------'
	#puts hc.city_id
	#puts hc.publish_datetime.
	#puts hc.forecast_datetime
	#puts hc.AQI
	#puts hc.main_pol 
	#puts hc.grade
	#puts hc.pm25
	#puts hc.pm10
	#puts hc.SO2
	#puts hc.CO
	#puts hc.NO2
	#puts hc.O3
	#puts hc.VIS
end

#strtime = Time.mktime(Time.new.strftime("%Y%m%d")+'08')
# strtime = Time.new.strftime("%Y%m%d")+'08'
strtime = Time.at(Time.now.to_i - 86400).strftime("%Y%m%d")+'08'
# puts strtime

# strtime = '2016012708'
puts strtime
# byebuy
path = "/mnt/share/Temp/station/#{strtime[0,8]}/"

# Read hua bei city, do not read data of these city.
firstline = true
hb_city = Array.new
IO.foreach("vendor/station_hb.EXT") do |line| 
	if firstline
		firstline = false
		next
	end
	post_number = line[1,7]
	latitude = line[8,8]
	longitude = line[16,8]
	city_name_pinyin = line[25,18].strip
	hb_city << city_name_pinyin
	#  city_name  = line[46..-4].strip
end



# cs.each do |c|
# puts c.city_name_pinyin
#if c.city_name_pinyin.rstrip.eql?('langfangshi')
# py = c.city_name_pinyin.strip
# py = 'hangzhoushi'
# py = 'pingdingshanshi'
# py = 'jinanshi'
# py = 'songyuanshi'
# py = 'wuhanshi'
# py = 'linyishi'
# py = 'linfenshi'
# py = 'rizhaoshi'
# py = 'anyangshi'
<<<<<<< HEAD
<<<<<<< HEAD
# py = 'hezeshi'
=======
py = 'hezeshi'
=======
# py = 'hezeshi'
>>>>>>> b90ede2214dc96a31b36e092746c86f7d13002de
# py = 'taianshi'
>>>>>>> master

# py = 'changchunshi'
# py = 'haerbinshi'

# py = 'hanzhongshi'
<<<<<<< HEAD
<<<<<<< HEAD
py = 'zhengzhoushi'
=======
# py = 'zhengzhoushi'
=======
py = 'zhengzhoushi'
>>>>>>> b90ede2214dc96a31b36e092746c86f7d13002de
# py = 'liuanshi'
>>>>>>> master

# py = 'wulumuqishi'
# py = 'hetiandiqu'
# py = 'kashidiqu'
# py = 'changjihuizuzizhiz'
<<<<<<< HEAD
=======
# py = 'kezilesukeerkezizi'
# py = 'tulufandiqu'
>>>>>>> master

c = City.find_by_city_name_pinyin(py)
# puts c
# next if hb_city.include?(py)


fn = "XJ_ENVAQFC_#{py}_#{strtime}_00000-07200.TXT"
f = File.open(path+fn) if File::exists?(path+fn) 
exit unless f
f.readlines[2..-1].each do |line| 
	parse_line(line, c)
end
f.close
puts fn+" successful!"
#end
# end

