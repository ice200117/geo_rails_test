#!/usr/bin/env ruby
#
# get_avg.rb
# Copyright (C) 2015-12-29 libaoxi <vagrant@vagrant-ubuntu-trusty-64>
#
# Distributed under terms of the MIT license.
#
def parse_lines_2014(line, factor="AQI")
	# sd = line[0,10]
	delta_hour = line[0,4].to_i
	# sdate = Time.local(sd[0,4],sd[4,2],sd[6,2],sd[8,2])
	if delta_hour>28&&delta_hour<53
		case factor
		when "AQI"
			return line[4,4].to_f
		when "pm25"
			return line[83,6].to_f
		when "pm10"
			return line[71,6].to_f
		when "SO2"
			return line[23,6].to_f
		when "CO"
			return line[47,6].to_f
		when "O3"
			return line[59,6].to_f
		when "NO2"
			return line[35,6].to_f
		else
			puts "else"
		end
	elsif delta_hour<29
		return "small" 
	elsif delta_hour>52
		return "big"
	end
end

def parse_lines_2015(line, factor="AQI")
	sd = line[0,10]
	delta_hour = line[11,3].to_i
	sdate = Time.local(sd[0,4],sd[4,2],sd[6,2],sd[8,2])
	if delta_hour>28&&delta_hour<53
		case factor
		when "AQI"
			return line[14,4].to_f
		when "pm25"
			return line[99,6].to_f
		when "pm10"
			return line[87,6].to_f
		when "SO2"
			return line[39,6].to_f
		when "CO"
			return line[63,6].to_f
		when "O3"
			return line[75,6].to_f
		when "NO2"
			return line[51,6].to_f
		else
			puts "else"
		end
	elsif delta_hour<29
		return "small" 
	elsif delta_hour>52
		return "big"
	end
end



puts "---begin---"
path="/mnt/share/Temp/station_9km_orig/201511/"
# path="/mnt/share/Temp/station_9km_orig/201512/"
path1="/mnt/share/Temp/station_9km_orig/201511/201511/"
# path1="/mnt/share/Temp/station_9km_orig/201512/201512/"
#path = "/mnt/share/Temp/station_9km_orig/"
# path_w="/vagrant/201412/"

# Read hua bei city, do not read data of these city.
firstline = true
hb_city = Array.new
IO.foreach("vendor/station.EXT_9km") do |line| 
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

# file_time=Time.local(2014,11,1) #月数据文件夹名字


w2 = File.open(path1+'201512.txt',"w")
w2.puts("date    AQI    pm25     pm10   SO2     CO     O3    NO2")
	
hb_city.each do |c|
	puts c
	filename = "#{c}.txt"
	w = File.open(path1+filename,"w")
	w1 = File.open(path1+filename+'_m',"w")
	factors = ["AQI", "pm25", "pm10", "SO2", "CO", "O3", "NO2"]
	w.puts("date    AQI    pm25     pm10   SO2     CO     O3    NO2")
	month_ary={}
	month_ary["AQI"] = []
	month_ary["pm25"] = []
	month_ary["pm10"] = []
	month_ary["SO2"] = []
	month_ary["CO"] = []
	month_ary["O3"] = []
	month_ary["NO2"] = []

	path_sum=0
	Dir::entries(path).each do |dirname|
		next if dirname.size < 7
		# puts dirname
		sdate = Time.local(dirname[0,4],dirname[4,2],dirname[6,2])
		# sdate=sdate-1.day
		str_date=sdate.yesterday.strftime("%Y%m%d")
		# puts  str_date
		#filename = "XJ_ENVAQFC_0052_HEBE_Langfang_#{dirname}20_00000-07200.TXT"
		#filename = "XJ_ENVAQFC_0001_BEIJ_Nanjiao_#{dirname}20_00000-07200.TXT"
		#filename = "XJ_ENVAQFC_0002_BEIJ_Nanjiao_#{dirname}20_00000-07200.TXT"
		# filename = "XJ_ENVAQFC_#{c}_#{dirname}20_00000-07200.TXT"
		filename = "XJ_ENVAQFC_#{c}_#{str_date}20_00000-07200.TXT_orig"
		# filename = "XJ_ENVAQFC_langfangshi_#{str_date}20_00000-07200.TXT_orig"
		f = File.open(path+dirname+"/"+filename,"r") if File.exists?(path+dirname+"/"+filename)
		next unless f
		path_sum+=1
	end
	# puts path_sum
	# while()
	Dir::entries(path).each do |dirname|
		next if dirname.size < 7
		# puts dirname
		sdate = Time.local(dirname[0,4],dirname[4,2],dirname[6,2])
		# sdate=sdate-1.day
		str_date=sdate.yesterday.strftime("%Y%m%d")
		# puts  str_date
		filename = "XJ_ENVAQFC_#{c}_#{str_date}20_00000-07200.TXT_orig"
		# filename = "XJ_ENVAQFC_langfangshi_#{str_date}20_00000-07200.TXT_orig"
		f = File.open(path+dirname+"/"+filename,"r") if File.exists?(path+dirname+"/"+filename)
		next unless f
		# puts f
		ary = Array.new
		hs = {}
		hs["AQI"] = []
		hs["pm25"] = []
		hs["pm10"] = []
		hs["SO2"] = []
		hs["CO"] = []
		hs["O3"] = []
		hs["NO2"] = []
		datalines = f.readlines
		datalines[25..55].each do |line|
			factors.each do |f|
				tmp = parse_lines_2015(line, f)
				if tmp.class == 0.0.class
					# puts sdate.to_s+delta_hour.to_s
					ary << tmp if f == "AQI"
					hs[f] << tmp
				elsif tmp == "small"
					next
				elsif tmp == "big"
					break
				end	
			end
		end
		# p ary.size
		if ary.size == 24
			avg = {}
			factors.each do |f|
				avg[f] = hs[f].inject(0){|sum,x| sum+=x}/ary.length 
				month_ary[f] << avg[f]
			end
			line = dirname
			avg.each_value { |a| line = line + "  " + a.round(4).to_s }
			w.puts(line)
		else
			w.puts(dirname+" "+"数据个数有错误！")
		end

		# puts 'zqq mon',month_ary["AQI"].length
		# puts 'zqq path',path_sum

		# if path_sum==month_ary["AQI"].length
		if path_sum==month_ary['AQI'].length
			puts 'OK'
			month_ary_temp={}
			factors.each do |f|
				month_ary_temp[f]=month_ary[f].inject(0){|sum,x| sum+=x}/month_ary[f].length
			end
			line = c+"_"+sdate.month.to_s+"_month_avg"
			month_ary_temp.each_value { |a| line = line + "  " + a.round(4).to_s }
			w1.puts(line)
			w2.puts(line)
		end

	end
	w.close
end
puts "---end---"
