require_relative 'city_enum.rb'

CityEnum.china_city_74.each do |city_name|
	city = City.find_by_city_name(city_name)
	puts HourlyCityForecastAirQuality.new.city_forecast(city.city_name_pinyin)
end
