class WeatherForecast < ActiveRecord::Base
	belongs_to :city
	validates_uniqueness_of :city_id,:publish_datetime,:forecast_datetime,:message=>"数据重复！"

    #获取预测数据
    def get_forecast(citypy)
        city_name_encode = ERB::Util.url_encode(City.find_by_city_name_pinyin(citypy).city_name)
        options = Hash.new
        headers={'apikey' => 'f8484c1661a905c5ca470b0d90af8d9f'}
        options[:headers] = headers
        url = "http://apis.baidu.com/showapi_open_bus/weather_showapi/address?area=#{city_name_encode}&needMoreDay=1"
        response = HTTParty.get(url,options)
        json = JSON.parse(response.body)
        # puts 0 if json['showapi_res_error'] == 0
        forecast_data = Hash.new
        json['showapi_res_body'].each do |k,v|
            if k[-1].to_i > 0 
                tq = get_tq(v)
                forecast_data[tq['day']] = tq
            end
        end
        temp = ForecastRealDatum.new.air_quality_forecast(citypy)
        temp.each do |k,v|
            v["fore_lev"] = get_lev(v["AQI"])
            time = k.to_time.strftime("%Y%m%d")
            if forecast_data[time] != nil
                forecast_data[time].merge!(v)
            end
        end
    end
    #天气处理与get_forecast合作使用
    def get_tq(f1)
        tq = Hash.new
        tq['tq'] = f1['day_weather']
        if f1['day_air_temperature'][-1] == '℃'
            tq['temp1'] = f1['day_air_temperature'][0,f1['day_air_temperature'].size-1]
        else
            tq['temp1'] = f1['day_air_temperature'] 
        end
        tq['temp2'] = f1['night_air_temperature']
        if f1['day_wind_direction'] == '无持续风向' && f1['night_wind_direction'] == '无持续风向'
            tq['wd'] = f1['day_wind_direction']
        elsif f1['day_wind_direction'] != '无持续风向' && f1['night_wind_direction'] == '无持续风向'
            tq['wd'] = f1['day_wind_direction']
        elsif f1['day_wind_direction'] == '无持续风向' && f1['night_wind_direction'] != '无持续风向'
            tq['wd'] = f1['night_wind_direction']
        elsif f1['day_wind_direction'] != '无持续风向' && f1['night_wind_direction'] != '无持续风向'
            if f1['day_wind_direction'] == f1['night_wind_direction'] 
                tq['wd'] = f1['day_wind_direction']
            elsif f1['day_wind_direction'] != f1['night_wind_direction'] 
                #tq['wd'] = f1['day_wind_direction']+'~'+f1['night_wind_direction']
            end
        end
        dw = f1['day_wind_power']
        nw = f1['night_wind_power']
        def wind_power(wp)
            return '' unless wp
            return wp[0,2] if wp[0,2] == '微风'
            for e in (0...wp.size)
                return wp[0,e+1] if wp[e] == '级'
            end		
        end
        dw = wind_power(dw)
        nw = wind_power(nw)
        if dw == nw
            tq['ws'] = dw
        elsif dw != nw
            dw[0].to_i > nw[0].to_i ? tq['ws'] = nw + '~' + dw : tq['ws'] = dw + '~' + nw
        end
        date = f1['day'].to_time
        if date.day==Time.now.day
            tq['date']= date.month.to_s.to_s+date.strftime("月%d日")+' '+'今天'
        elsif date.day==1.days.from_now.day
            tq['date']= date.month.to_s.to_s+date.strftime("月%d日")+' '+'明天'
        elsif date.day==2.days.from_now.day
            tq['date']= date.month.to_s.to_s+date.strftime("月%d日")+' '+'后天'
        else
            tq['date']= date.month.to_s.to_s+date.strftime("月%d日")+' '+'星期'+Custom::Week.week_of_time(date)
        end
        tq['day'] = f1['day'].to_time.strftime("%Y%m%d")
        tq
    end

    def get_lev(a)
        if (0 .. 50) === a
            lev = 'you'
        elsif (50 .. 100) === a
            lev = 'yellow'
        elsif (100 .. 150) === a
            lev = 'qingdu'
        elsif (150 .. 200) === a
            lev = 'zhong'
        elsif (200 .. 300) === a
            lev = 'zhongdu'
        elsif (300 .. 500) === a
            lev = 'yanzhong'
        end
    end
end
