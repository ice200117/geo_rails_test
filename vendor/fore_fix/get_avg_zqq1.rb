#!/usr/bin/env ruby
#
# get_avg.rb
# Copyright (C) 2015-12-29 libaoxi <vagrant@vagrant-ubuntu-trusty-64>
#
# Distributed under terms of the MIT license.
#
def parse_lines(line, factor="AQI")
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

puts "---begin---"
path="/mnt/share/Temp/station_9km/2014-new/"
#path = "/mnt/share/Temp/station_9km_orig/"
w = File.open(path+"0.txt","w")
factors = ["AQI", "pm25", "pm10", "SO2", "CO", "O3", "NO2"]
w.puts("date    AQI    pm25     pm10   SO2     CO     O3    NO2")
# path_w="/vagrant/201412/"
Dir::entries(path).each do |dirname|
	next if dirname.size < 6
	puts dirname
	sdate = Time.local(dirname[0,4],dirname[4,2],dirname[6,2])
	# sdate=sdate-1.day
	str_date=sdate.strftime("%Y%m%d")
	# puts  str_date
    filename = "XJ_ENVAQFC_0052_HEBE_Langfang_#{dirname}20_00000-07200.TXT"
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
			tmp = parse_lines(line, f)
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
		end
		line = dirname
		avg.each_value { |a| line = line + "  " + a.round(4).to_s }
		w.puts(line)
	else
		w.puts(dirname+" "+"数据个数有错误！")
	end
end
w.close
puts "---end---"
