class CreateWeatherForecasts < ActiveRecord::Migration
	def change
		create_table :weather_forecasts do |t|
			t.integer  :city_id
			t.datetime :publish_datetime
			t.datetime :forecast_datetime
			t.string   :high
			t.string   :low
			t.string   :high
			t.string   :low
			t.string   :day_type
			t.string   :day_fx
			t.string   :day_fl
			t.string   :night_type
			t.string   :night_fx
			t.string   :night_fl
			t.timestamps
		end
	end
end
