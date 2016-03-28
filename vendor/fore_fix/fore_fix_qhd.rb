#!/usr/bin/env ruby
#
# fore_fix_qhd.rb
# Copyright (C) 2016 libaoxi <693879111@qq.com>
#
# Distributed under terms of the MIT license.
#

def read_qhd_file
	path="/mnt/share/Temp/station_9km_orig/20160303/"
	name = "XJ_ENVAQFC_qinhuangdaoshi_2016030220_00000-07200.TXT_orig"
	hs=Hash.new
	File.open(path+file,"r").readlines[1..-1].each do |line|
		sd = line[0,10]
		delta_hour = line[11,3]
		sdate = Time.local(sd[0,4],sd[4,2],sd[6,2],sd[8,2])
		forecast_datetime = sdate+delta_hour.to_i*3600
		aqi = line[14,4]
		hs[forecast_datetime]=aqi
	end
	hs
end

def seven_hours_avg(time)
	temp=Array.new
	data=read_qhd_file()
	(-3..3).each do |n|
		temp<<data[time+n*3600] if !data[time+n*3600].nil?
	end
	temp.inject(0){|sum,x| sum+=x}/v.length
end

time=Time.now.begining_of_day+9*3600
ChinaCitiesHour.where("publish_datetime >= ? AND city_id 11",time).each do |line|
	line.AQI=seven_hours_avg(line.forecast_datetime)
	line.save
end
