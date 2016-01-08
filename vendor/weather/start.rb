require_relative 'city_number.rb'
require_relative 'weather'
require_relative 'save_in_db'

day_flag = false
day_flag = true if WeatherDay.last.publish_datetime.day != Time.now.yesterday.day
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
		save_day(data['resp']['yesterday'],c.id) if day_flag
		puts 'WeatherDay '+k+' is ok!' if data['resp']['error'] == nil && day_flag
		save_forecast(data['resp'],c.id) if forecast
		puts 'WeatherForecast '+k+' is ok!' if data['resp']['error'] == nil && forecast
	else
		puts k+' is null!' if data['resp']['error'] != nil
	end
end
