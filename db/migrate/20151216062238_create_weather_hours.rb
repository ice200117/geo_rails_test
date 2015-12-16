class CreateWeatherHours < ActiveRecord::Migration
	def change
		create_table :weather_hours do |t|
			t.integer  :city_id
			t.datetime :publish_datetime
			t.integer  :wendu
			t.string   :fengli
			t.string   :shidu
			t.string   :fengxiang
			t.datetime :sunrise
			t.datetime :sunset
			t.string   :shizhu
			t.timestamps
		end
	end
end
