#!/usr/bin/env ruby
#
# fix_forecast_by_least_square.rb
# Copyright (C) 2016 libaoxi <693879111@qq.com>
#
# Distributed under terms of the MIT license.
#
def fix_forecast_by_least_square
    stime = Time.now.yesterday.beginning_of_hour
    mtime = Time.now.beginning_of_hour
    etime = mtime.end_of_day
    City.all.each do |city|
        cch = ChinaCitiesHour.where(data_real_time:(stime..mtime),city_id:city.id).to_a.group_by_hour(&:data_real_time)
        next if cch.size == 0
<<<<<<< HEAD
        # frd1 = ForecastRealDatum.where(forecast_datetime:(stime..mtime),city_id:city.id).to_a.group_by_hour(&:forecast_datetime)
        frd1 = HourlyCityForecastAirQuality.where(publish_datetime:(Time.now.yesterday..Time.now.yesterday.end_of_day),forecast_datetime:(stime..mtime),city_id:city.id).to_a.group_by(&:forecast_datetime)
        next if frd1.size == 0
        # frd2 = ForecastRealDatum.where(forecast_datetime:(mtime+3600..etime),city_id:city.id)
        frd2 = HourlyCityForecastAirQuality.where(publish_datetime:(Time.now.yesterday..Time.now.yesterday.end_of_day),forecast_datetime:(mtime+3600..etime),city_id:city.id)
        next if frd2.size == 0
=======
        maxtime =  HourlyCityForecastAirQuality.order('publish_datetime').where(city_id:city.id).last.publish_datetime
        frd1 = HourlyCityForecastAirQuality.where(publish_datetime:maxtime,forecast_datetime:(stime..mtime),city_id:city.id).to_a.group_by_hour(&:forecast_datetime)
        # frd1 = HourlyCityForecastAirQuality.where(publish_datetime:(Time.now.yesterday..Time.now.yesterday.end_of_day),forecast_datetime:(stime..mtime),city_id:city.id).to_a.group_by(&:forecast_datetime)
        next if frd1.size == 0
        frd2_f = ForecastRealDatum.where(forecast_datetime:((mtime+3600)..etime),city_id:city.id)
        frd2_h = HourlyCityForecastAirQuality.where(publish_datetime:maxtime,forecast_datetime:((mtime+3600)..etime),city_id:city.id)
        # frd2 = HourlyCityForecastAirQuality.where(publish_datetime:(Time.now.yesterday..Time.now.yesterday.end_of_day),forecast_datetime:(mtime+3600..etime),city_id:city.id)
        next if frd2_f.size == 0 or frd2_h.size == 0
>>>>>>> 79b564126e701493629d412f98b512090235bf2e
        aqix = Array.new
        aqiy = Array.new
        frd1.each do |k,v|
            next if cch[k].nil? or v.size == 0 or cch[k].size == 0
<<<<<<< HEAD
            puts v[0].forecast_datetime.hour.to_s + ' ' + v[0].AQI.to_s
=======
>>>>>>> 79b564126e701493629d412f98b512090235bf2e
            aqix << v[0].AQI
            aqiy << cch[k][0].AQI
        end
        next if aqix.size == 0 or aqiy.size == 0
<<<<<<< HEAD
        puts city.city_name
        lsqr = Math.least_squares(aqix,aqiy)
        frd2.each do |l|
            # l.update(AQI: lsqr.call(l.AQI))
            puts l.forecast_datetime.hour.to_s+' '+lsqr.call(l.AQI).to_s
=======
        puts city.city_name 
        lsqr = Math.least_squares(aqix,aqiy)
        frd2_f = frd2_f.to_a.group_by_hour(&:forecast_datetime)
        frd2_h.to_a.group_by_hour(&:forecast_datetime).each do |k,v|
            # l.update(AQI: lsqr.call(l.AQI))
            next if frd2_f[k].size == 0 or v.size == 0
            frd2_f[k][0].update(AQI:lsqr.call(v[0].AQI))
            puts v[0].forecast_datetime.hour.to_s+' '+lsqr.call(v[0].AQI).to_s
>>>>>>> 79b564126e701493629d412f98b512090235bf2e
        end
    end
    puts 'fix_forecast_by_least_square end'
end
