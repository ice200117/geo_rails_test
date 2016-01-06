#!/usr/bin/ruby
require_relative "fore_fix.rb"

def calculate
	save_path = "/mnt/share/Temp/station_9km_orig/#{strtime[0,8]}/"
	write_path = "/mnt/share/Temp/calculate/#{strtime[0,8]}/"
	City.all.each do |c|
		puts c.city_name.strip
		py = c.city_name_pinyin.strip
		fn = "XJ_ENVAQFC_#{py}_#{yesterday_str}_00000-07200.TXT_orig"
		fnout = "XJ_ENVAQFC_#{py}_#{yesterday_str}_00000-07200.TXT"
		f = File.open(path+fn) if File::exists?(path+fn) 
		next unless f
		f_save = File.open(save_path+fn,'w')
		puts fnout+' successful'

		#遍历预报文件，预报数据/观测数据，生成数组begin
		f.readlines[2..-1].each do |line|
			hs=get_aqi(line)
			next if hs[:forecast_datetime]>Time.now
			tmp = Array.new
			tmp << "data_real_time >= ? and data_real_time <= ? and city_id = ?"
			tmp << hs[:forecast_datetime].beginning_of_hour
			tmp << hs[:forecast_datetime].end_of_hour
			tmp << c.id
			data = ChinaCitiesHour.where(tmp)
			next if data.length == 0
			f_save.puts(c.city_name+' '+c.city_name_pinyin+': 差值=>'+(hs[:AQI].to_i-data[0].to_i).to_s+' 比值=>'hs[:AQI].AQI/data[0].AQI) if !data[0].AQI.nil?
		end
		#end
		f_save.close()
	end
end
calculate
