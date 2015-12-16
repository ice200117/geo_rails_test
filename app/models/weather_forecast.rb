class WeatherForecast < ActiveRecord::Base
	belongs_to :city
	validates_uniqueness_of :city_id,:publish_datetime,:forecast_datetime,:message=>"数据重复！"
end
