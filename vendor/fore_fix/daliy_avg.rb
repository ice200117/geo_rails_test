#!/usr/bin/ruby
require_relative "fore_fix.rb"

class DaliyAvg
	#城市
	#25公里平均值
	def self.avg_25
		#时间设定
		strtime = Time.now.yesterday.strftime("%Y%m%d")
		time = strtime+'08'
		#路径设定
		# path = "/mnt/share/Temp/station_orig/#{strtime[0,8]}/"
		path = "/mnt/share/Temp/station/#{strtime[0,8]}/"
		filename = '25km_daliy.txt'
		Dir::mkdir(path) if !Dir.exists?(path)
		File.delete(path+filename) if File.exists?(path+filename)
		daliy_avg=File.open(path+filename,"w")
		#城市遍历
		city_ary=Array['beijingshi','langfangshi','baodingshi','zhengzhoushi','jinanshi','taiyuanshi','shenyangshi','hangzhoushi']
		city_ary.each do |c|
			daliy_avg.puts(City.find_by_city_name_pinyin(c).city_name)
			#处理文件目录
			fn = "XJ_ENVAQFC_#{c}_#{time}_00000-07200.TXT"
			f = File.open(path+fn) if File::exists?(path+fn)
			next unless f
			puts c
			num = 0 #初始化计数器
			tmp = Array.new
			tmp_time = Time.now
			f.readlines[17..-1].each do |line| #25km 从第18行开始
				num += 1
				hs = get_aqi(line)
				tmp << hs[:AQI].to_i
				if num == 24 || line[11,3] == '120'  #计数24之后 计数器归零
					num = 0 
					daliy_avg.puts(tmp_time.strftime("%Y%m%d")+'-'+c+'-AQI: '+(tmp.inject(0){|sum,x| sum+=x}/tmp.length).to_s)
					tmp_time = tmp_time.to_time.tomorrow
					tmp.clear 
				end
			end
			daliy_avg.puts(City.find_by_city_name_pinyin(c).city_name+' '+'end')
		end
		daliy_avg.close
	end
	#9公里平均值
	def self.avg_9
		#时间设定
		strtime = Time.now.strftime("%Y%m%d")
		time = strtime.to_time.yesterday.strftime("%Y%m%d")+'20'
		#路径设定
		# path = "/mnt/share/Temp/station_9km_orig/#{strtime[0,8]}/"
		path = "/mnt/share/Temp/station_9km/#{strtime[0,8]}/"
		filename = '9km_daliy.txt'
		Dir::mkdir(path) if !Dir.exists?(path)
		File.delete(path+filename) if File.exists?(path+filename)
		daliy_avg=File.open(path+filename,"w")
		#城市遍历
		city_ary=Array['beijingshi','langfangshi','baodingshi','taiyuanshi','shenyangshi','changchunshi','hengshuishi']
		city_ary.each do |c|
			daliy_avg.puts(City.find_by_city_name_pinyin(c).city_name)
			#处理文件目录
			fn = "XJ_ENVAQFC_#{c}_#{time}_00000-07200.TXT"
			f = File.open(path+fn) if File::exists?(path+fn)
			next unless f
			puts c
			num = 0 #初始化计数器
			tmp = Array.new
			tmp_time = Time.now
			f.readlines[5..-1].each do |line| #25km 从第18行开始
				num += 1
				hs = get_aqi(line)
				tmp << hs[:AQI].to_i
				if num == 24 || line[11,3] == '120'  #计数24之后 计数器归零
					num = 0 
					daliy_avg.puts(tmp_time.strftime("%Y%m%d").to_s+'-'+c+'-AQI: '+(tmp.inject(0){|sum,x| sum+=x}/tmp.length).to_s)
					tmp_time = tmp_time.tomorrow
					tmp.clear 
				end
			end
			daliy_avg.puts(City.find_by_city_name_pinyin(c).city_name+' '+'end')
		end
		daliy_avg.close
	end
end
#start-----------------------
# puts "--start--9km--"
 DaliyAvg.avg_9
# puts "--start--25km--"
# DaliyAvg.avg_25
# puts "OK"
