class CreateTempBdHours < ActiveRecord::Migration
  def change
    create_table :temp_bd_hours do |t|
      t.integer  "city_id"
    t.float    "SO2"
    t.float    "NO2"
    t.float    "CO"
    t.float    "O3"
    t.float    "pm10"
    t.float    "pm25"
    t.float    "AQI"
    t.string   "level"
    t.string   "main_pol"
    t.string   "weather"
    t.string   "winddirection"
    t.datetime "data_real_time"
    t.float    "zonghezhishu"
    t.integer  "windscale"
    t.integer  "windspeed"
    t.integer  "humi"
    t.integer  "temp"
      t.timestamps
    end
  end
end
