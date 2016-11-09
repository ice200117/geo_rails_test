#!/usr/bin/ruby
#hs = HourlyCityForecastAirQuality.all
#hs.each { |h| h.destroy }


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
strtime = Time.new.strftime("%Y%m%d")+'08'
#puts strtime

strtime = '2015041608'
#puts strtime

#path = "/mnt/share/Temp/station/#{strtime[0,8]}/"
path = "/mnt/share/station/"

cs = City.all
cs.each do |c|
  puts c.city_name_pinyin
  if c.city_name_pinyin.rstrip.eql?('langfangshi')
    #py = c.city_name_pinyin.strip
    #fn = "XJ_ENVAQFC_#{py}_#{strtime}_00000-07200.TXT"
    fn = "XJ_ENVAQFC_0052_HEBE_Langfang_2015042320_00000-07200.TXT"
    f = File.open(path+fn) if File::exists?(path+fn)
    puts fn
    next unless f
    f.readlines[2..-1].each do |line|
      parse_line(line, c)
    end
    puts fn+" successful!"
    f.close
  end
end
