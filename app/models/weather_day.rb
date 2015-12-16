class WeatherDay < ActiveRecord::Base
	belongs_to :city
	validates :city_id, uniqueness: { scope: :publish_datetime,message: "数据重复！" }
end
