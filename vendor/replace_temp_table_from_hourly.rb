# 预报数据修正，将预报数据出来当天前8个小时改为检测值
def replace_eight_hours(stime,etime)
    forecast_datetime = (stime..etime)
    publish_datetime = (stime.beginning_of_day.yesterday..stime.beginning_of_day-1)
    paramfrd = {publish_datetime:publish_datetime,forecast_datetime:forecast_datetime} 
    paramcch = {data_real_time:forecast_datetime}
    frd = ForecastRealDatum.where(paramfrd).to_a.group_by{|x| x.forecast_datetime.hour.to_s+'_'+x.city_id.to_s}
    cch = ChinaCitiesHour.where(paramcch).to_a.group_by{|x| x.data_real_time.hour.to_s+'_'+x.city_id.to_s}
    return nil if frd.size==0 or cch.size==0
    frd.each do |k,v|
        # Thread.new do
            next if cch[k].nil?
            v[0].AQI = cch[k][0].AQI
            v[0].SO2 = cch[k][0].SO2
            v[0].NO2 = cch[k][0].NO2
            v[0].CO = cch[k][0].CO
            v[0].O3 = cch[k][0].O3
            v[0].pm10 = cch[k][0].pm10
            v[0].pm25 = cch[k][0].pm25
            # puts v[0].as_json
            v[0].save
            puts k.to_s+' save ok!'
        # end
    end
end
