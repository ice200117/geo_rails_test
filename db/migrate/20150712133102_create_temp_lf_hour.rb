class CreateTempLfHour < ActiveRecord::Migration
  def change
    create_table :temp_lf_hours do |t|
	  t.integer  "city_id"
      t.float "SO2"
      t.float "NO2"
      t.float "CO"
      t.float "O3"
      t.float "pm10"
      t.float "pm25"
      t.float "zonghezhishu"
      t.float "AQI"
      t.integer "level"
	  t.string   "main_pol"
      t.timestamps
    end
  end
end
