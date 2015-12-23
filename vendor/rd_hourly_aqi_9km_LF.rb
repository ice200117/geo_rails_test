#!/usr/bin/ruby
#hs = HourlyCityForecastAirQuality.all
#hs.each { |h| h.destroy }


def parse_line(line, c)
	# hc = HourlyCityForecastAirQuality.new
	sd = line[0,10]
	delta_hour = line[11,3]
	sdate = Time.local(sd[0,4],sd[4,2],sd[6,2],sd[8,2])

	# hc.publish_datetime = sdate
	# hc.forecast_datetime = sdate+delta_hour.to_i*3600
	hc = HourlyCityForecastAirQuality.find_or_create_by(city_id: c.id, publish_datetime: sdate, forecast_datetime: sdate+delta_hour.to_i*3600 )
	hc.AQI = line[14,4]
	# hc.AQI = hc.AQI*2.51   # liubin 10/5/2015
	hc.main_pol = line[18,13].strip
	hc.grade = line[31,1]
	hc.pm25 = line[99,6]
	hc.pm10 = line[87,6]
	hc.SO2 = line[39,6]
	hc.CO = line[63,6]
	hc.NO2 = line[51,6]
	hc.O3 = line[75,6]
	hc.VIS = line[32,7]

	# hc.city_id = c.id
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
yesterday_str = Time.at(Time.now.to_i - 86400).strftime("%Y%m%d")+'20'
strtime = Time.new.strftime("%Y%m%d")+'20'
puts strtime

#strtime = '2015040808'
#puts strtime

path = "/mnt/share/Temp/station_9km/#{strtime[0,8]}/"

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

# cs = Array.new
# cs << City.find_by_city_name_pinyin('langfangshi')
# cs << City.find_by_city_name_pinyin('huzhoushi')
#cs = City.all
# cs.each do |c|
#puts c.city_name_pinyin
#if c.city_name_pinyin.rstrip.eql?('langfangshi')
# py = c.city_name_pinyin.strip
 py = 'langfangshi'
 # py = 'handanshi'
c = City.find_by_city_name_pinyin(py)
fn = "XJ_ENVAQFC_#{py}_#{yesterday_str}_00000-07200.TXT"
puts fn
# next unless hb_city.include?(py)
f = File.open(path+fn) if File::exists?(path+fn) 
exit unless f
f.readlines[2..-1].each do |line| 
	parse_line(line, c)
end
f.close
puts fn+" update database successful!"
#end
# end

