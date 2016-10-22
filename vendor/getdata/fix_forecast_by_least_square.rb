#!/usr/bin/env ruby
#
# fix_forecast_by_least_square.rb
# Copyright (C) 2016 libaoxi <693879111@qq.com>
#
# Distributed under terms of the MIT license.
#
def fix_forecast_by_least_square
  mtime = Time.now.beginning_of_hour
  stime = mtime.yesterday.beginning_of_hour
  etime = mtime.end_of_day
  City.all.each do |city|
    next if city.city_name_pinyin != 'langfangshi'
    cch = ChinaCitiesHour.where(data_real_time:(stime..mtime),city_id:city.id).to_a.group_by_hour(&:data_real_time)
    next if cch.size == 0
    frd1 = ForecastRealDatum.where(forecast_datetime:(stime..mtime),city_id:city.id).to_a.group_by_hour(&:forecast_datetime)
    next if frd1.size == 0
    frd2 = ForecastRealDatum.where(forecast_datetime:(mtime+3600..etime),city_id:city.id)
    next if frd2.size == 0
    aqix = Array.new
    aqiy = Array.new
    frd1.each do |k,v|
      next if cch[k].nil? or v.size == 0 or cch[k].size == 0
      aqix << v[0].AQI
      aqiy << cch[k][0].AQI
    end
    next if aqix.size == 0 or aqiy.size == 0
    puts city.city_name
    lsqr = Math.least_squares(aqix,aqiy)
    frd2.each do |l|
      l.update(AQI: lsqr.call(l.AQI))
      puts l.forecast_datetime.hour.to_s+' '+lsqr.call(l.AQI).to_s
    end
  end
  puts 'fix_forecast_by_least_square end'
end
fix_forecast_by_least_square()
