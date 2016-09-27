#!/usr/bin/ruby

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
    :SO2 => l[5],
    :CO => l[9],
    :NO2 => l[7],
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
  wind = Custom::DataMath.getDSFromUv(l[23],l[24])
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

yesterday_str = Time.at(Time.now.to_i - 86400).strftime("%Y%m%d")+'20'
strtime = Time.now.strftime("%Y%m%d")+'20'

puts strtime
path = "/mnt/share/Temp/station_9km/#{strtime[0,8]}/"
path15 = "/mnt/share/Temp/station_15km_orig/#{yesterday_str}/"
# path = "/Users/baoxi/Workspace/temp/station_9km/#{strtime[0,8]}/"
# path15 = "/Users/baoxi/Workspace/temp/station_15km_orig/#{yesterday_str}/"

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
  fn = "XJ_ENVAQFC_#{py}_#{yesterday_str}_00000-07200.TXT"
  fw = "CN_MET_#{py}_#{yesterday_str}_00000-12000.TXT"
  next unless hb_city.include?(py) #非华北地区城市跳过
  f = nil
  f = File.open(path+fn) if File::exists?(path+fn)
  next unless f
  c.forecast_real_data.destroy_all
  c.hourly_city_forecast_air_qualities.where(publish_datetime: Time.zone.parse(yesterday_str)).delete_all

  f1 = nil
  f1 = File.open(path15+fw) if File::exists?(path15+fw)
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

py = 'qinhuangdaoshi'
tmp=City.find_by_city_name_pinyin(py).hourly_city_forecast_air_qualities.order(:publish_datetime).last(120).group_by_day(&:forecast_datetime)
#Custom::Redis.set(py,tmp,3600*24)
