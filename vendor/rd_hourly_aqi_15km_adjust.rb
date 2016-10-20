#!/usr/bin/ruby
#hs = HourlyCityForecastAirQuality.all
#hs.each { |h| h.destroy }


def parse_line(line, c)
  
  #hc = HourlyCityForecastAirQuality.new
  c.forecast_real_data.destroy_all
  sd = line[0,10]
  delta_hour = line[11,3]
  sdate = Time.local(sd[0,4],sd[4,2],sd[6,2],sd[8,2])

  #hc.city_id = c.id
  #hc.publish_datetime = sdate
  #hc.forecast_datetime = sdate+delta_hour.to_i*3600
  
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

  # Put data to real time table.
  rc = ForecastRealDatum.find_or_create_by(city_id: c.id, publish_datetime: sdate, forecast_datetime: sdate+delta_hour.to_i*3600 )
  rc.AQI = line[14,4].to_f*2.round
  puts rc.AQI
  rc.main_pol = line[18,13].strip
  rc.grade = line[31,1]
  rc.pm25 = line[99,6]
  rc.pm10 = line[87,6]
  rc.SO2 = line[39,6]
  rc.CO = line[63,6]
  rc.NO2 = line[51,6]
  rc.O3 = line[75,6]
  rc.VIS = line[32,7]
  rc.save
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
#if Time.new.hour >18
#	strtime = Time.new.strftime("%Y%m%d")+'20'
#else
#	strtime = (Time.new-1.day).strftime("%Y%m%d")+'20'
#end
strtime = (Time.new-1.day).strftime("%Y%m%d")+'20'
#strtime = Time.at(Time.now.to_i - 86400).strftime("%Y%m%d")+'08'
puts 'deal date = ', strtime

#strtime = '2016012720'
puts strtime

# path = "/mnt/share/Temp/station/#{strtime[0,8]}/"
# path = "/mnt/share/Temp/station_15km_orig/#{strtime[0,8]}/"
path = "/mnt/share/Temp/station_15km_orig/#{strtime}/"

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
  

cs = City.all
cs.each do |c|
  puts c.city_name_pinyin
  #if c.city_name_pinyin.rstrip.eql?('langfangshi') or c.city_name_pinyin.rstrip.eql?('beijingshi') or c.city_name_pinyin.rstrip.eql?('baodingshi')
  #if c.city_name_pinyin.rstrip.eql?('shijiazhuangshi')
  if c.city_name_pinyin.rstrip.eql?('beijingshi')
  py = c.city_name_pinyin.strip

  #next if hb_city.include?(py)


  fn = "CN_ENVAQFC_#{py}_#{strtime}_00000-12000.TXT"
  f = nil
  f = File.open(path+fn) if File::exists?(path+fn) 
  puts path+fn
  next unless f
  f.readlines[2..-1].each do |line| 
    parse_line(line, c)
  end
  f.close
  puts fn+" update database successful!"
  end
end

