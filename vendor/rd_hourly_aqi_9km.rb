#!/usr/bin/ruby
#hs = HourlyCityForecastAirQuality.all
#hs.each { |h| h.destroy }


def parse_line(line, c)
	#hc = HourlyCityForecastAirQuality.new

	sd = line[0,10]
	delta_hour = line[11,3]
	sdate = Time.local(sd[0,4],sd[4,2],sd[6,2],sd[8,2])

	hc = HourlyCityForecastAirQuality.from_partition(sdate).find_or_create_by(city_id: c.id, publish_datetime: sdate, forecast_datetime: sdate+delta_hour.to_i*3600 )
	hc.destroy

	hcc = {
		:city_id => c.id,
		:publish_datetime => sdate,
		:forecast_datetime => sdate+delta_hour.to_i*3600,
		:AQI => line[14,4],
	    :main_pol => line[18,13].strip,
	    :grade => line[31,1],
	    :pm25 => line[99,6],
	    :pm10 => line[87,6],
	    :SO2 => line[39,6],
	    :CO => line[63,6],
	    :NO2 => line[51,6],
	    :O3 => line[75,6],
	    :VIS => line[32,7]
	}

	#HourlyCityForecastAirQuality.create(hcc)

	#hc = HourlyCityForecastAirQuality.from_partition(sdate).find_or_create_by(city_id: c.id, publish_datetime: sdate, forecast_datetime: sdate+delta_hour.to_i*3600 )
	#hc.AQI = line[14,4]
	#hc.main_pol = line[18,13].strip
	#hc.grade = line[31,1]
	#hc.pm25 = line[99,6]
	#hc.pm10 = line[87,6]
	#hc.SO2 = line[39,6]
	#hc.CO = line[63,6]
	#hc.NO2 = line[51,6]
	#hc.O3 = line[75,6]
	#hc.VIS = line[32,7]
	#hc.save

	#rc = ForecastRealDatum.find_or_create_by(city_id: c.id, publish_datetime: sdate, forecast_datetime: sdate+delta_hour.to_i*3600 )
	#rc.AQI = line[14,4]
	#rc.main_pol = line[18,13].strip
	#rc.grade = line[31,1]
	#rc.pm25 = line[99,6]
	#rc.pm10 = line[87,6]
	#rc.SO2 = line[39,6]
	#rc.CO = line[63,6]
	#rc.NO2 = line[51,6]
	#rc.O3 = line[75,6]
	#rc.VIS = line[32,7]
	#rc.save

	hcc 

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

#strtime = '20160403'
#yesterday_str  = '2016040220'
puts strtime

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

#cs = Array.new
#cs << City.find_by_city_name_pinyin('langfangshi')
#cs << City.find_by_city_name_pinyin('huzhoushi')
cs = City.all
hcs = []
cs.each do |c|
	puts c.city_name_pinyin
	#if c.city_name_pinyin.rstrip.eql?('langfangshi')
	py = c.city_name_pinyin.strip
	fn = "XJ_ENVAQFC_#{py}_#{yesterday_str}_00000-07200.TXT"
	# puts fn
	next unless hb_city.include?(py)
	f = nil
	f = File.open(path+fn) if File::exists?(path+fn) 
	next unless f
	c.forecast_real_data.destroy_all
	f.readlines[2..-1].each do |line| 
		hcs << parse_line(line, c)
	end
	f.close
	puts fn+" update database successful!"
	if py=='qinhuangdaoshi'
		tmp=City.find_by_city_name_pinyin(py).hourly_city_forecast_air_qualities.order(:publish_datetime).last(120).group_by_day(&:forecast_datetime)
		Custom::Redis.set(py,tmp,3600*24)
	end
end
HourlyCityForecastAirQuality.create(hcs)
ForecastRealDatum.create(hcs)
