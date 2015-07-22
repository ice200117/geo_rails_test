class CreateTempSfcitiesYear < ActiveRecord::Migration
  def change
    create_table :temp_sfcities_years do |t|
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
	  t.float		"SO2_change_rate"
	  t.float		"NO2_change_rate"
	  t.float		"CO_change_rate"
	  t.float		"O3_change_rate"
	  t.float		"pm10_change_rate"
	  t.float		"pm25_change_rate"
	  t.float		"zongheindex_change_rate"
      t.timestamps
    end
  end
end
