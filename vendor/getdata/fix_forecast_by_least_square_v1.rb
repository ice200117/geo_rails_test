#!/usr/bin/env ruby

require 'linefit'
def fix_forecast_by_least_square
    stime = Time.now.yesterday.beginning_of_hour
    mtime = Time.now.beginning_of_hour
    etime = mtime.end_of_day

    cch = ChinaCitiesHour.where(data_real_time:(stime..mtime)).to_a.group_by{|x| x.city_id}
    return nil if cch.size == 0
    maxtime =  HourlyCityForecastAirQuality.last.publish_datetime
    frd1 = HourlyCityForecastAirQuality.where(publish_datetime:maxtime,forecast_datetime:(stime..mtime)).to_a.group_by{|x| x.city_id}
    return nil if frd1.size == 0
    frd2_f = ForecastRealDatum.where(forecast_datetime:((mtime+3600)..etime)).to_a.group_by{|x| x.city_id}
    frd2_h = HourlyCityForecastAirQuality.where(publish_datetime:maxtime,forecast_datetime:((mtime+3600)..etime)).to_a.group_by{|x| x.city_id}
    return nil if frd2_f.size == 0 or frd2_h.size == 0

    threads = []
    frd2_f.keys.each do |cityid|
        aqix = Hash.new
        aqiy = Hash.new
        next if frd1[cityid].nil? or cch[cityid].nil?
        frd1[cityid].sort_by{|x| x.forecast_datetime}.each{|x| aqix[x.forecast_datetime.hour] = x.AQI}
        cch[cityid].sort_by{|x| x.data_real_time}.each do |x|
            hour = x.data_real_time.hour
            aqiy[hour] = x.AQI unless aqix[hour].nil?
        end
        aqix = aqix.values
        aqiy = aqiy.values
        return nil if aqix.size < 5 or aqiy.size < 5
        linefit = LineFit.new
        linefit.setData(aqix,aqiy,(0...aqix.size).to_a)
        frd2_h[cityid].each do |l|
            l.update(AQI:linefit.forecast(l.AQI))
            puts cityid.to_s+' '+l.forecast_datetime.hour.to_s+' '+linefit.forecast(l.AQI).to_s
        end
    end
    puts 'fix_forecast_by_least_square end'
end
