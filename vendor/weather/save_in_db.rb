require_relative 'city_number.rb'
require_relative 'weather'

def save_hour(data,id)
	w = WeatherHour.find_or_create_by(city_id:id,publish_datetime:data['updatetime'].to_time)
	return false if !w.wendu.nil?
	w.city_id = id
	w.publish_datetime = data['updatetime'].to_time
	w.wendu = data['wendu']
	w.fengli = data['fengli']
	w.shidu = data['shidu']
	w.fengxiang = data['fengxiang']
	w.sunrise = data['sunrise_1']
	w.sunset = data['sunset_1']
	w.zhishu = data['zhishus']['zhishu'].to_s
	w.save
	return true
end
def save_day(data,id)
	w = WeatherDay.new
	w.city_id = id
	w.publish_datetime = data['date_1'].to_time
	w.high = data['high_1']
	w.low = data['low_1']
	w.day_type = data['day_1']['type_1']
	w.day_fx = data['day_1']['fx_1']
	w.day_fl = data['day_1']['fl_1']
	w.night_type = data['night_1']['type_1']
	w.night_fx = data['night_1']['fx_1']
	w.night_fl = data['night_1']['fl_1']
	w.save
end
def save_forecast(data,id)
	data['forecast']['weather'].each do |t|
		w = WeatherForecast.new
		w.city_id = id
		w.publish_datetime = data['updatetime'].to_time
		w.forecast_datetime = t['date'].to_time
		w.high = t['high']
		w.low = t['low']
		w.day_type = t['day']['type']
		w.day_fx = t['day']['fengxiang']
		w.day_fl = t['day']['fengli']
		w.night_type = t['night']['type']
		w.night_fx = t['night']['fengxiang']
		w.night_fl = t['night']['fengli']
		w.save
	end
end

# hour = false
# hour = true if WeatherHour.last.publish_datetime != Weather::Weather.new.all_weather_info_of_city['resp']['updatetime'].to_time
day = false
day = true if WeatherDay.last.publish_datetime.day != Time.now.yesterday.day
forecast = false
forecast = true if WeatherForecast.last.publish_datetime.day != Time.now.day
#城市循环
city_number.each do |k,v|
	c = City.where("city_name LIKE ?",k+'%')
	data = Weather::Weather.new(v).all_weather_info_of_city
	if data.nil?
		puts k+' is error!'
		next 
	end
	if data['resp']['error'] == nil && c.size != 0
		c = c[0]
		puts 'WeatherHour '+k+' is ok!' if save_hour(data['resp'],c.id)  
		save_day(data['resp']['yesterday'],c.id) if day	
		puts 'WeatherDay '+k+' is ok!' if data['resp']['error'] == nil && day
		save_forecast(data['resp'],c.id) if forecast
		puts 'WeatherForecast '+k+' is ok!' if data['resp']['error'] == nil && forecast
	else
		puts k+' is null!' if data['resp']['error'] != nil
	end
end
