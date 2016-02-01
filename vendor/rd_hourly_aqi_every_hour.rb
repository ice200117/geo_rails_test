#!/usr/bin/ruby
#hs = HourlyCityForecastAirQuality.all
#hs.each { |h| h.destroy }


def parse_line(line, c)

	sd = line[0,10]
	delta_hour = line[11,3]
	sdate = Time.local(sd[0,4],sd[4,2],sd[6,2],sd[8,2])

	#hc.city_id = c.id
	#hc.publish_datetime = sdate
	#hc.forecast_datetime = sdate+delta_hour.to_i*3600

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
	puts c.city_name+'写入成功'
end

def save_in_db(c)
	#strtime = Time.mktime(Time.new.strftime("%Y%m%d")+'08')
	strtime = Time.now.yesterday.strftime("%Y%m%d")
	yesterday_str = strtime+'08'
	# strtime = '20160126'
	# yesterday_str = '2016012608'

	path = "/mnt/share/Temp/station/#{strtime[0,8]}/"

	# Read hua bei city, do not read data of these city.
	firstline = true
	hb_city = Array.new

	# puts c.city_name_pinyin
	py = c.city_name_pinyin.strip

	fn = "XJ_ENVAQFC_#{py}_#{yesterday_str}_00000-07200.TXT"
	f = File.open(path+fn) if File::exists?(path+fn) 
	return unless f
	f.readlines[2..-1].each do |line| 
		parse_line(line, c)
	end
	f.close
	# puts fn+" update database successful!"
end
