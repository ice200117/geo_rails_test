class CreateMonitorPointDays < ActiveRecord::Migration
	def change
		create_table :monitor_point_days do |t|
			t.integer  "point_id"
			t.float    "SO2"
			t.float    "NO2"
			t.float    "CO"
			t.float    "O3"
			t.float    "O3_8h"
			t.float    "pm10"
			t.float    "pm25"
			t.float    "AQI"
			t.string   "level"
			t.string   "main_pol"
			t.string   "quality"
			t.float    "SO2_change_rate"
			t.float    "NO2_change_rate"
			t.float    "CO_change_rate"
			t.float    "O3_change_rate"
			t.float    "O3_8h_change_rate"
			t.float    "pm10_change_rate"
			t.float    "pm25_change_rate"
			t.float    "zongheindex_change_rate"	
			t.string   "weather"
			t.string   "temp"
			t.string   "humi"
			t.string   "winddirection"
			t.string   "windspeed"
			t.integer  "windscale"
			t.float    "zonghezhishu"
			t.datetime "data_real_time"
			t.datetime "created_at"
			t.datetime "updated_at"
			t.timestamps
		end
	end
end
