#!/usr/bin/ruby
require_relative "./fore_fix.rb"
require_relative 'daliy_avg'

#start---------------
puts "--start--"
yesterday_str = Time.at(Time.now.to_i - 86400).strftime("%Y%m%d")+'20'
strtime = Time.now.strftime("%Y%m%d")

#strtime = '20160403' 
#yesterday_str = '2016040220' 
puts strtime
puts yesterday_str

#path = "/mnt/share/Temp/station/#{strtime[0,8]}/"
path = "/mnt/share/Temp/station_9km_orig/#{strtime[0,8]}/"

# path_fix = "/vagrant/fix/station_9km/#{strtime[0,8]}/"
 # path_fix = "/mnt/share/Temp/station_9km_orig/#{strtime[0,8]}/"
path_fix = "/mnt/share/Temp/station_9km/#{strtime[0,8]}/"

Dir::mkdir(path_fix) if !Dir.exists?(path_fix)
f_avg=File.open(path_fix+"avg.txt","w")

Dir::mkdir(path_fix) if !Dir.exists?(path_fix)
after_avg=File.open(path_fix+"after_avg.txt","w")
after_avg.puts(Time.now)

default_9km_city = default_9km()
cs = City.all
cs.each do |c|
	puts c.city_name
	py = c.city_name_pinyin.strip
	
	# fn = "XJ_ENVAQFC_#{py}_#{yesterday_str}_00000-07200.TXT"
	 # fn = "XJ_ENVAQFC_#{py}_#{yesterday_str}_00000-07200.TXT_adjust"
	 fn = "XJ_ENVAQFC_#{py}_#{yesterday_str}_00000-07200.TXT_orig"
	fnout = "XJ_ENVAQFC_#{py}_#{yesterday_str}_00000-07200.TXT"
	# fnout = "XJ_ENVAQFC_#{py}_#{yesterday_str}_00000-07200.TXT_adjust"
	# next unless hb_city.include?(py)
	f = File.open(path+fn) if File::exists?(path+fn) 
	next unless f
	puts fnout+' successful'

	#begin判断预报城市是否与观测城市匹配
	if ChinaCitiesHour.find_by_city_id(c.id).nil?
		# FileUtils.cp f,path_fix+fnout
		file = File.open(path_fix+fnout,"w")
		f.rewind
		first_line = f.readlines
		file.puts(first_line[0])
		if default_9km_city[py] == nil
			tmp = default_9km_city['other']
		else
			tmp = default_9km_city[py]
		end
		first_line[1..-1].each do |line|
			file.puts(fixed_write_txt(line,tmp))
		end
		file.close
		f.close()
		after_avg.puts(c.city_name_pinyin.to_s+"-default-"+" "+tmp.to_s) #最终系数写入文件
		next
	end
	#end

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
		# model = get_model_by_name(c.city_name)
		data = ChinaCitiesHour.where(tmp)
		next if data.length == 0
		# byebug if hs[:AQI].to_i/data[0].AQI&&data[0].AQI != 0 
		lev[get_lev(hs[:AQI].to_i)] << hs[:AQI].to_i/data[0].AQI if !data[0].AQI.nil?
	end
	avg = Hash['you' =>nil,'yellow' =>nil,'qingdu'=>nil,'zhong'=>nil,'zhongdu'=>nil,'zhongdu'=>nil,'yanzhong'=>nil]
	lev.each do |k,v|
		next if v.length == 0
		avg[k] = v.inject(0){|sum,x| sum+=x}/v.length
	end
	f_avg.puts(c.city_name_pinyin.to_s+" "+avg.to_s)

	avg_s = 1
	avg.each do |k,v|
		tmp = nil
		if default_9km_city[c.city_name_pinyin] == nil
			tmp = default_9km_city['other'][k]
		elsif default_9km_city[c.city_name_pinyin] != nil
			tmp = default_9km_city[c.city_name_pinyin][k]
		end
		if v != nil
			avg[k] = (tmp*2+v*1)/3
		else
			avg[k] = tmp
		end
	end
	after_avg.puts(c.city_name_pinyin.to_s+" "+avg.to_s) #最终系数写入文件
	file = File.open(path_fix+fnout,"w")
	f.rewind
	first_line = f.readlines
	file.puts(first_line[0])
	first_line[1..-1].each do |line|
		file.puts(fixed_write_txt(line,avg))
	end
	file.close
	f.close()
end
f_avg.close
after_avg.close
puts "--start--9km--"
DaliyAvg.avg_9
puts "OK"
