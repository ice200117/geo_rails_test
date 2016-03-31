class CreateMonitorPointHours < ActiveRecord::Migration
	def change
		create_table :monitor_point_hours do |t|
			t.integer  "point_id"
			t.float    "SO2"
			t.float    "NO2"
			t.float    "CO"
			t.float    "O3"
			t.float    "pm10"
			t.float    "pm25"
			t.float    "AQI"
			t.string   "level"
			t.string   "main_pol"
			t.string   "quality"
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
