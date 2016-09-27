#!/usr/bin/ruby
#hs = HourlyCityForecastAirQuality.all
#hs.each { |h| h.destroy }

def parse_line(line, c)
  l = line.split(' ')
  sd = l[0][0,10]
  delta_hour = l[0][11,3]
  sdate = Time.local(sd[0,4],sd[4,2],sd[6,2],sd[8,2])

  hcc = {
    :city_id => c.id,
    :publish_datetime => sdate,
    :forecast_datetime => sdate+delta_hour.to_i*3600,
    :AQI => l[1],
    :main_pol => l[2].strip,
    :grade => l[3],
    :pm25 => l[15],
    :pm10 => l[13],
    :SO2 => l[5], :CO => l[9], :NO2 => l[7],
    :O3 => l[11],
    :VIS => l[4]
  }
  hcc
end

def fw_line(line, c)
  l = line.split(' ')
  sd = l[0][0,10]
  delta_hour = l[0][11,3]
  sdate = Time.local(sd[0,4],sd[4,2],sd[6,2],sd[8,2])
  wind = wind_utils(l[23].to_f,l[24].to_f)
  { sdate+delta_hour.to_i*3600 =>{
    :ps => l[1],
    :tg => l[2],
    :rc => l[3],
    :rn => l[4],
    :ttp => l[3].to_f+l[4].to_f,
    :ter => l[5],
    :xmf => l[6],
    :dmf => l[7],
    :cor => l[8],
    :xlat => l[9],
    :xlon => l[10],
    :lu => l[11],
    :pbln => l[12],
    :pblr => l[13],
    :shf => l[14],
    :lhf => l[15],
    :ust => l[16],
    :swd => l[17],
    :lwd => l[18],
    :swo => l[19],
    :lwo => l[20],
    :t2m => l[21],
    :q2m => l[22],
    :u10 => l[23],
    :v10 => l[24],
    :wd => wind[:d],
    :ws => wind[:s],
    :pslv => l[25],
    :pwat => l[26],
    :clfrlo => l[27],
    :clfrmi => l[28],
    :clfrhi => l[29]
  }}
end
#strtime = Time.mktime(Time.new.strftime("%Y%m%d")+'08')
if Time.new.hour >18
	strtime = Time.new.strftime("%Y%m%d")+'20'
else
	strtime = (Time.new-1.day).strftime("%Y%m%d")+'20'
end
#strtime = Time.at(Time.now.to_i - 86400).strftime("%Y%m%d")+'08'
puts 'deal date = ', strtime
# strtime = '2016092520'
puts strtime

# path = "/mnt/share/Temp/station/#{strtime[0,8]}/"
path = "/mnt/share/Temp/station_15km_orig/#{strtime}/"
# path = "/Users/baoxi/Workspace/temp/station_15km_orig/#{strtime}/"

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
hcs = []
cs.each do |c|
  puts c.city_name_pinyin
  py = c.city_name_pinyin.strip
  next if hb_city.include?(py) #华北城市跳过

  fn = "CN_ENVAQFC_#{py}_#{strtime}_00000-12000.TXT"
  fw = "CN_MET_#{py}_#{strtime}_00000-12000.TXT"
  f = nil
  f = File.open(path+fn) if File::exists?(path+fn)
  next unless f
  c.forecast_real_data.destroy_all
  c.hourly_city_forecast_air_qualities.where(publish_datetime: Time.zone.parse(strftime[0,8])).delete_all

  f1 = nil
  f1 = File.open(path+fw) if File::exists?(path+fw)
  tmp = Hash.new
  if f1
    f1.readlines[2..-1].each do |line|
      tmp.merge!(fw_line(line, c))
    end
  end

  f.readlines[2..-1].each do |line|
    td = parse_line(line, c)
    td.merge!(tmp[td[:forecast_datetime]]) if !tmp[td[:forecast_datetime]].nil?
    hcs << td
  end

  f.close
  puts fn+" update database successful!"
end
HourlyCityForecastAirQuality.create(hcs)
ForecastRealDatum.create(hcs)
