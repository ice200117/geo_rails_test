#!/usr/bin/ruby
require_relative "./fore_fix.rb"
# require_relative 'daliy_avg'

#---类注释---
#修正某个城市的预报
#2016-01-27
#修正9公里的预报数据
#---类注释---

#修正一个城市，
#参数：c(City的对象)
def city(c)
	return if c == nil
	#start---------------
	puts "--#{c.city_name}--"
	strtime = Time.now.strftime("%Y%m%d")
	yesterday_str = Time.now.yesterday.strftime("%Y%m%d")+'20'
	
	path = "/mnt/share/Temp/station_9km/#{strtime[0,8]}/"
	path_fix = path

	default_9km_city = default_9km() #调用缺省系数
	py = c.city_name_pinyin.strip

	fn = "XJ_ENVAQFC_#{py}_#{yesterday_str}_00000-07200.TXT"
	fnout = ".XJ_ENVAQFC_#{py}_#{yesterday_str}_00000-07200.TXT.swap"
	f = File.open(path+fn) if File::exists?(path+fn) 
	return unless f

	#判断预报城市是否与观测城市匹配
	if ChinaCitiesHour.find_by_city_id(c.id).nil?
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
		return
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
		next if hs[:forecast_datetime]<Time.now.beginning_of_day||hs[:forecast_datetime]>Time.now.end_of_hour
		tmp = Array.new
		tmp << "data_real_time >= ? and data_real_time <= ? and city_id = ?"
		tmp << hs[:forecast_datetime].beginning_of_hour
		tmp << hs[:forecast_datetime].end_of_hour
		tmp << c.id
		data = ChinaCitiesHour.where(tmp)
		next if data.length == 0
		lev[get_lev(hs[:AQI].to_i)] << hs[:AQI].to_i/data[0].AQI if !data[0].AQI.nil?
	end
	avg = Hash['you' =>nil,'yellow' =>nil,'qingdu'=>nil,'zhong'=>nil,'zhongdu'=>nil,'zhongdu'=>nil,'yanzhong'=>nil]
	lev.each do |k,v|
		next if v.length == 0
		avg[k] = v.inject(0){|sum,x| sum+=x}/v.length
	end

	avg_s = 1
	avg.each do |k,v|
		tmp = nil
		if default_9km_city[c.city_name_pinyin] == nil
			tmp = default_9km_city['other'][k]
		elsif default_9km_city[c.city_name_pinyin] != nil
			tmp = default_9km_city[c.city_name_pinyin][k]
		end
		if v != nil
			avg[k] = (tmp*6+v*1)/7
		else
			avg[k] = tmp
		end
	end
	Dir::mkdir(path_fix) if !Dir.exists?(path_fix)
	file = File.open(path_fix+fnout,"w")
	f.rewind
	first_line = f.readlines
	file.puts(first_line[0])
	first_line[1..-1].each do |line|
	 	hs = get_aqi(line)
		if hs[:forecast_datetime]<Time.now.beginning_of_hour||hs[:forecast_datetime]>Time.now.end_of_day
			file.puts(line)
		else
			# puts line
			file.puts(fixed_write_txt(line,avg))
		end
	end
	file.close
	f.close()
	FileUtils.mv path+fnout,path+fn if File::exists?(path+fnout)
end
city(City.find_by_city_name_pinyin('langfangshi'))
