class CreateTempSfcitiesHours < ActiveRecord::Migration
  def change
    create_table :temp_sfcities_hours do |t|
    	t.integer "city_id"
		t.float "SO2"
		t.float "NO2"
		t.float "CO"
		t.float "O3"
		t.float "pm10"
		t.float "pm25"
		t.float "AQI"
		t.string "quality"
		t.string "main_pollutant"
		t.string "weather"
		t.string "temp"
		t.string "humi"
		t.string "winddirection"
		t.string "windspeed"
		t.datetime "data_real_time"
      t.timestamps
    end
  end
end
