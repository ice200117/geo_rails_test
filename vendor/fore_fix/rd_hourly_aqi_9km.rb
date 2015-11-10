#!/usr/bin/ruby
require_relative "./fore_fix.rb"

def get_aqi(line)
	sd = line[0,10]
	delta_hour = line[11,3]
	sdate = Time.local(sd[0,4],sd[4,2],sd[6,2],sd[8,2])

	hs = Hash.new
	hs[:forecast_datetime] = sdate+delta_hour.to_i*3600
	hs[:AQI] = line[14,4]
	hs
end

def parse_line(line, c)

	hc = HourlyCityForecastAirQuality.new
	sd = line[0,10]
	delta_hour = line[11,3]
	sdate = Time.local(sd[0,4],sd[4,2],sd[6,2],sd[8,2])
	hc.publish_datetime = sdate
	hc.forecast_datetime = sdate+delta_hour.to_i*3600
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

	hc.city_id = c.id
	hc.save

end

def set_file
	yesterday_str = Time.at(Time.now.to_i - 86400).strftime("%Y%m%d")+'20'
	strtime = Time.new.strftime("%Y%m%d")+'20'
	path = "/vagrant/station/#{strtime[0,8]}/"
	Dir.mkdir(path) if 

end

#start---------------
puts "--start--"
yesterday_str = Time.at(Time.now.to_i - 86400).strftime("%Y%m%d")+'20'
strtime = Time.new.strftime("%Y%m%d")+'20'

path = "/vagrant/#{strtime[0,8]}/"

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
end

cs = City.all
cs.each do |c|
	py = c.city_name_pinyin.strip
	fn = "XJ_ENVAQFC_#{py}_#{yesterday_str}_00000-07200.TXT"
	puts fn
	next unless hb_city.include?(py)
	f = File.open(path+fn) if File::exists?(path+fn) 
	next unless f

	lev = Hash.new
	lev['you'] = Array.new
	lev['yellow'] = Array.new
	lev['qingdu'] = Array.new
	lev['zhong'] = Array.new
	lev['zhongdu'] = Array.new
	lev['yanzhong'] =Array.new

	f.readlines[2..-1].each do |line|
		hs=get_aqi(line)
		tmp = Array.new
		tmp << "data_real_time >= ? and data_real_time <= ? and city_id = ?"
		tmp << hs[:forecast_datetime].beginning_of_hour
		tmp << hs[:forecast_datetime].end_of_hour
		tmp << c.id
		data = get_model_by_name(c.city_name).where(tmp)
		lev[get_lev(hs[:AQI])] << hs[:AQI]/data[0].AQI
	end

	f.readlines[2..-1].each do |line| 
		parse_line(line, c)
	end
	f.close
	puts fn+" successful!"
end
