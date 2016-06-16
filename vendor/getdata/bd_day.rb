#!/usr/bin/env ruby
#
# gethourdata_of_qinhuangdao.rb
# Copyright (C) 2016 libaoxi <693879111@qq.com>
#
# Distributed under terms of the MIT license.
#

def day
	mp=MonitorPoint.where("city_id = 14")
	mp.each do |l|
		line = {}
		tmp = someday_data(Time.now.yesterday,l.id)
		line=tmp if !tmp.nil?
		line['id'] = l.id
		line['time'] = Time.now.yesterday
		line['pointname']=l.pointname
		line['city_id'] = 14
		MonitorPointDay.new.save_with_arg(line)
	end
end

#计算某天的数据
def someday_data(time,id)
	so2=Array.new
	no2=Array.new
	o3=Array.new
	co=Array.new
	pm10=Array.new
	pm25=Array.new
	temp=MonitorPointHour.where("monitor_point_id = ? AND data_real_time >= ? AND data_real_time <=?",id,time.beginning_of_day,time.end_of_day)
	return nil if temp.length==0
	temp.each do |t|
		so2<<t.SO2 if !t.SO2.nil?
		no2<<t.NO2 if !t.NO2.nil?
		o3<<t.O3_8h if t.data_real_time>=time.beginning_of_day+8*3600
		co<<t.CO if !t.CO.nil?
		pm10<<t.pm10 if !t.pm10.nil?
		pm25<<t.pm25 if !t.pm25.nil?
	end
	mpd=Hash.new
	mpd['so2']=avg(so2)
	mpd['no2']=avg(no2)
	mpd['o3']=o3.max
	mpd['co']=avg(co)
	mpd['pm10']=avg(pm10)
	mpd['pm25']=avg(pm25)
	mpd
end

def avg(array)
	sum=0
	array.each{|x| sum+=x}
	if array.length != 0
		sum/array.length if array.length!=0
	else
		0
	end
end

#百分位计算
def percentile(array,num)
	#co o3百分位数计
	array = array.sort
	ind=array.length*num
	(ind.is_a?Float) ? array[ind.floor].to_f : (array[ind].to_f+array[ind+1].to_f)/2
end
day()
