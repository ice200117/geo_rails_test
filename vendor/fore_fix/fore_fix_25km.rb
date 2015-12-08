#!/usr/bin/ruby
require_relative "fore_fix.rb"
require_relative 'daliy_avg'

#start---------------
puts "--start--"
yesterday_str = Time.at(Time.now.to_i - 86400).strftime("%Y%m%d")+'08'
strtime = Time.now.yesterday.strftime("%Y%m%d")

 # strtime = '20151120' 
 # yesterday_str = '2015112008' 
puts strtime
puts yesterday_str

#path = "/mnt/share/Temp/station/#{strtime[0,8]}/"
path = "/mnt/share/Temp/station_orig/#{strtime[0,8]}/"

# path_fix = "/vagrant/fix/station_25km/#{strtime[0,8]}/"
#path_fix = "/mnt/share/Temp/station_orig/#{strtime[0,8]}/"
path_fix = "/mnt/share/Temp/station/#{strtime[0,8]}/"

Dir::mkdir(path_fix) if !Dir.exists?(path_fix)
f_avg=File.new(path_fix+"avg.txt","w")

Dir::mkdir(path_fix) if !Dir.exists?(path_fix)
after_avg=File.new(path_fix+"after_avg.txt","w")
after_avg.puts(ChinaCitiesHour.last.data_real_time) 

default_25km_city = default_25km()
cs = City.all
cs.each do |c|
	puts c.city_name.strip
	py = c.city_name_pinyin.strip
	# fn = "XJ_ENVAQFC_#{py}_#{yesterday_str}_00000-07200.TXT"
	fn = "XJ_ENVAQFC_#{py}_#{yesterday_str}_00000-07200.TXT_orig"
	# fnout = "XJ_ENVAQFC_#{py}_#{yesterday_str}_00000-07200.TXT_adjust"
	fnout = "XJ_ENVAQFC_#{py}_#{yesterday_str}_00000-07200.TXT"
	# next unless hb_city.include?(py)
	f = File.open(path+fn) if File::exists?(path+fn) 
	next unless f
	puts fnout+' successful'

	if ChinaCitiesHour.find_by_city_id(c.id).nil?
		# FileUtils.cp f,path_fix+fnout
		file = File.open(path_fix+fnout,"w")
		f.rewind
		first_line = f.readlines
		file.puts(first_line[0])
		if default_25km_city[py] == nil
			tmp = default_25km_city['other']
		else
			tmp = default_25km_city[py]
		end
		first_line[1..-1].each do |line|
			file.puts(fixed_write_txt(line,tmp))
		end
		file.close
		f.close()
		after_avg.puts(c.city_name_pinyin.to_s+"-defualt-"+" "+tmp.to_s) #最终系数写入文件
		next
	end

	lev = Hash.new
	lev['you'] = Array.new
	lev['yellow'] = Array.new
	lev['qingdu'] = Array.new
	lev['zhong'] = Array.new
	lev['zhongdu'] = Array.new
	lev['yanzhong'] =Array.new
	#遍历预报文件，预报数据/观测数据，生成数组begin
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
		lev[get_lev(hs[:AQI].to_i)] << hs[:AQI].to_i/data[0].AQI if !data[0].AQI.nil?
	end
	#end
	#数组求平均值begin
	avg = Hash['you'=>nil,'yellow' =>nil,'qingdu'=>nil,'zhong'=>nil,'zhongdu'=>nil,'yanzhong'=>nil]
	lev.each do |k,v|
		next if v.length == 0
		avg[k] = v.inject(0){|sum,x| sum+=x}/v.length
	end
	#end
	f_avg.puts(c.city_name_pinyin.to_s+" "+avg.to_s) #系数写入avg.txt

	avg_s = 1
	avg.each do |k,v|
		tmp = nil
		if default_25km_city[c.city_name_pinyin] == nil
			tmp = default_25km_city['other'][k]
		elsif default_25km_city[c.city_name_pinyin] != nil
			tmp = default_25km_city[c.city_name_pinyin][k]
		end
		if v!=nil
			avg[k] = (tmp*5+v)/6
		else
			avg[k] = tmp
		end
	end
	#end
	after_avg.puts(c.city_name_pinyin.to_s+" "+avg.to_s) #平均系数写入after_avg.txt

	file = File.open(path_fix+fnout,"w")
	f.rewind
	first_line = f.readlines
	file.puts(first_line[0])
	first_line[1..-1].each do |line|
		file.puts(fixed_write_txt(line,avg))
	end
	file.close()
	f.close()
end
f_avg.close
after_avg.close
# puts "--start--25km--"
DaliyAvg.avg_25
puts "OK"
