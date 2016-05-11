class ForecastRealDatum < ActiveRecord::Base
	belongs_to :city

	def self.city_forecast_by_pinyin(pinyin)
		c = City.find_by_city_name_pinyin(pinyin)
		return nil unless c
		city_forecast(c)
	end

	def self.city_forecast(c)
		firstime = true
		cf = Hash.new
		hf = []
		c.forecast_real_data.each do |ch|
			if firstime
				cf[:city_name] = c.city_name
				cf[:publish_datetime] = ch.publish_datetime.strftime('%Y-%m-%d_%H')
				firstime = false
			end
			hf << {forecast_datetime: ch.forecast_datetime.strftime('%Y-%m-%d_%H'), 
		  AQI: ch.AQI.round, 
		  main_pol: ch.main_pol, 
		  grade: ch.grade,
		  pm2_5: ch.pm25,
		  pm10: ch.pm10,
		  SO2: ch.SO2,
		  CO: ch.CO,
		  NO2: ch.NO2,
		  O3: ch.O3,
		  VIS: ch.VIS }
			#end
		end
		cf[:forecast_data] = hf
		return cf
	end

	def self.all_cities
		achf = []
		City.where("id < 388").includes(:forecast_real_data).each do |c|
			puts c.city_name
			firstime = true
			cf = Hash.new
			hf = []
			c.forecast_real_data.each do |ch|

				if firstime
					cf[:city_name] = c.city_name
					cf[:publish_datetime] = ch.publish_datetime.strftime('%Y-%m-%d_%H')
					firstime = false
				end
			
				#if ch.forecast_datetime > Time.now
					hf << {forecast_datetime: ch.forecast_datetime.strftime('%Y-%m-%d_%H'), 
			AQI: ch.AQI.round, 
			main_pol: ch.main_pol, 
			grade: ch.grade,
			pm2_5: ch.pm25,
			pm10: ch.pm10,
			SO2: ch.SO2,
			CO: ch.CO,
			NO2: ch.NO2,
			O3: ch.O3,
			VIS: ch.VIS }
				#end
			end
			if hf.length > 0
				cf[:forecast_data] = hf
				achf << cf
			end
		end
		achf
	end
end
