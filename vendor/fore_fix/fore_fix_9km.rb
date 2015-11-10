#!/usr/bin/ruby
require_relative "./fore_fix.rb"

#获取预报数据的预报时间，AQI
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

def fixed_write_txt(line,avg)
	aqi = line[14,4].to_i
	#line[14,4] = avg[get_lev(aqi)]*aqi if !avg[get_lev(aqi)].nil? 
	if !avg[get_lev(aqi)].nil? 
		fix_aqi = (avg[get_lev(aqi)]*aqi).round
		fix_aqi = 500 if fix_aqi > 500
		line[14,4] = " %3d" % fix_aqi
	end
	line
end

#start---------------
puts "--start--"
yesterday_str = Time.at(Time.now.to_i - 86400).strftime("%Y%m%d")+'20'
strtime = Time.now.strftime("%Y%m%d")

# strtime = '20151106' 
# yesterday_str = '2015110608' 
puts strtime
puts yesterday_str

#path = "/mnt/share/Temp/station/#{strtime[0,8]}/"
path = "/mnt/share/Temp/station_9km/#{strtime[0,8]}/"

path_fix = "/vagrant/fix/station_9km/#{strtime[0,8]}/"

Dir::mkdir(path_fix) if !Dir.exists?(path_fix)
File.delete(path_fix+"avg.txt") if File.exist?(path_fix+"avg.txt")
f_avg=File.new(path_fix+"avg.txt","w")

# Read hua bei city, do not read data of these city.
# firstline = true
# hb_city = Array.new
# IO.foreach("vendor/station_hb.EXT") do |line| 
# 	if firstline
# 		firstline = false
# 		next
# 	end
# 	post_number = line[1,7]
# 	latitude = line[8,8]
# 	longitude = line[16,8]
# 	city_name_pinyin = line[25,18].strip
# 	hb_city << city_name_pinyin
# end

cs = City.all
cs.each do |c|
	puts c.city_name_pinyin.strip
	py = c.city_name_pinyin.strip
	# fn = "XJ_ENVAQFC_#{py}_#{yesterday_str}_00000-07200.TXT"
	fn = "XJ_ENVAQFC_#{py}_#{yesterday_str}_00000-07200.TXT"
	fnout = "XJ_ENVAQFC_#{py}_#{yesterday_str}_00000-07200.TXT_adjust"
	# next unless hb_city.include?(py)
	f = File.open(path+fn) if File::exists?(path+fn) 
	next unless f
	puts fnout+' successful'

	if get_model_by_name(c.city_name).nil?
		FileUtils.cp f,path_fix+fnout
		next
	end

	lev = Hash.new
	lev['you'] = Array.new
	lev['yellow'] = Array.new
	lev['qingdu'] = Array.new
	lev['zhong'] = Array.new
	lev['zhongdu'] = Array.new
	lev['yanzhong'] =Array.new
	f.readlines[2..-1].each do |line|
		hs=get_aqi(line)
		next if hs[:forecast_datetime]>Time.now
		tmp = Array.new
		tmp << "data_real_time >= ? and data_real_time <= ? and city_id = ?"
		tmp << hs[:forecast_datetime].beginning_of_hour
		tmp << hs[:forecast_datetime].end_of_hour
		tmp << c.id
		model = get_model_by_name(c.city_name)
		data = model.where(tmp)
		next if data.length == 0
		lev[get_lev(hs[:AQI].to_i)] << data[0].AQI/hs[:AQI].to_i
	end
	avg = Hash.new
	lev.each do |k,v|
		next if v.length == 0
		avg[k] = v.inject(0){|sum,x| sum+=x}/v.length
	end
	#设置缺省系数，与计算得到的系数求平均值
	baodingshi = {'you' =>0.88,'yellow' => 1.08,'qingdu'=>1.1,'zhong'=>1.2,'zhongdu'=>1.65,'yanzhong'=>2.15 }
	changjiangkou = {'you'=>0.9,'yellow'=>0.9,'qingdu'=>1.28,'zhong'=>2.08,'zhongdu'=>2.48}
	jinanshi = {'you' =>0.8,'yellow' =>1,'qingdu'=>0.9,'zhong'=>1.1,'zhongdu'=>1.35,'yanzhong'=>1.55 }
	hebeishi = {'you' =>1,'yellow' =>1,'qingdu'=>1.08,'zhong'=>1.19,'zhongdu'=>1.45,'yanzhong'=>1.85 }
	langfangshi = {'you' =>0.8,'yellow' =>0.88,'qingdu'=>1,'zhong'=>1,'zhongdu'=>1.65,'yanzhong'=>2.05 }
	hangzhoushi = {'you' =>0.9,'yellow' =>0.8,'qingdu'=>1,'zhong'=>1.08,'zhongdu'=>1.88}
	zhengzhoushi = {'you' =>0.8,'yellow' =>1,'qingdu'=>1,'zhong'=>1.28,'zhongdu'=>1.35,'yanzhong' => 1.55}
	hetiandiq = {'yellow' =>2.28,'qingdu'=>1.38,'zhong'=>1.08}
	kashidiqu = hetiandiq 
	other = {'you' =>0.8,'yellow' =>1,'qingdu'=>1.78,'zhong'=>2.38,'zhongdu'=>2.58}

	cities_default=Hash.new
	cities_default[baodingshi] = baodingshi
	cities_default[changjiangkou] = changjiangkou
	cities_default[jinanshi] = jinanshi
	cities_default[hebeishi] = hebeishi
	cities_default[langfangshi] = langfangshi
	cities_default[hangzhoushi] = hangzhoushi
	cities_default[zhengzhoushi] = zhengzhoushi
	cities_default[hetiandiq] = hetiandiq
	cities_default[kashidiqu] = kashidiqu
	cities_default[other] = other

	
	avg_s = 1
	avg.each do |k,v|
		tmp = nil
		if cities_default[c.city_name_pinyin] == nil
			tmp = cities_default[other][k]
		elsif cities_default[c.city_name_pinyin] != nil
			tmp = cities_default[c.city_name_pinyin][k]
		end
		avg[k] = (tmp+v)/2 if tmp != nil
	end
	f_avg.puts(c.city_name.to_s+" "+avg.to_s)

	File.delete(path_fix+fnout) if File::exist?(path_fix+fnout)
	file = File.open(path_fix+fnout,"w")
	f.rewind
	first_line = f.readlines
	file.puts(first_line[0])
	first_line[1..-1].each do |line|
		file.puts(fixed_write_txt(line,avg))
	end
	f.close()
end
f_avg.close
puts "OK"
