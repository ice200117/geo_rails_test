#!/usr/bin/env ruby
#
# correction_calc.rb
# Copyright (C) 2016 liubin <ice200117@126.com>
#
# Distributed under terms of the MIT license.
#

NUM_DAY = 15

def average(arr)
	#arr.transpose.map {|x| x.reduce(:+)}/arr.size.to_f
	arr.reduce(:+)/arr.size.to_f
end

def get_monitor(c)
	# 获取监测小时值
	monitor_data_hour = ChinaCitiesHour.history_data_hour(c, NUM_DAY.days.ago.beginning_of_day)
	return nil if monitor_data_hour.size == 0
	average(monitor_data_hour.map { |a| a.second})
end

def get_fore24(c)
	# 获取预报24,48,72,96小时值
	forecast_data_hour = HourlyCityForecastAirQuality.history_data_hour(c, NUM_DAY.days.ago.beginning_of_day, 1)
	return nil if forecast_data_hour.size == 0
	average(forecast_data_hour.map { |a| a.second})
end


def calc(c)
	md_ave = get_monitor(c)
	fd_ave = get_fore24(c)
	return nil if md_ave.nil? or fd_ave.nil?
	md_ave/fd_ave
end

File.open("vendor/correction1.rb", "w+") do |aFile|
	aFile.syswrite("CORR={")
	City.all.each do |c|
		puts c.city_name_pinyin
		coe = calc(c)
		next if coe.nil?
		puts c.city_name_pinyin+':'+coe.to_s
		aFile.syswrite(",\n") unless c == City.first
		if  coe
			str = c.city_name_pinyin+':'+coe.to_s
			aFile.syswrite(str)
		end
	end
	aFile.syswrite("}")
end
