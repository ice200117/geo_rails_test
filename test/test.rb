#获取预测数据
def get_forecast
	city_name_encode = ERB::Util.url_encode("保定市")
	options = Hash.new
	headers={'apikey' => 'f8484c1661a905c5ca470b0d90af8d9f'}
	options[:headers] = headers
	url = "http://apis.baidu.com/showapi_open_bus/weather_showapi/address?area=#{city_name_encode}&needMoreDay=1"
	response = HTTParty.get(url,options)
	json = JSON.parse(response.body)
	puts 0 if json['showapi_res_error'] == 0
	weather = Array.new
	json['showapi_res_body'].each do |k,v|
		weather << get_tq(v) if k[-1].to_i > 0
	end

	temp = HourlyCityForecastAirQuality.new.air_quality_forecast('baodingshi')
	temp.each do |k,v|
		v["fore_lev"] = get_lev(v["AQI"])
		weather[k.strftime("%Y%m%d")]=weather[k.strftime("%Y%m%d")].merge(v)
	end
	weather
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
			tq['wd'] = f1['day_wind_direction']+'~'+f1['night_wind_direction']
		end
	end
	dw = f1['day_wind_power']
	nw = f1['night_wind_power']
	def wind_power(wp)
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
	tq[f1['day'].to_time.strftime("%Y%m%d")] = tq
end
puts get_forecast()
