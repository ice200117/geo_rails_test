class CreateForecastRealData < ActiveRecord::Migration
  def change
    create_table :forecast_real_data do |t|
      t.integer  "city_id"
      t.datetime "publish_datetime"
      t.datetime "forecast_datetime"
      t.float    "AQI"
      t.string   "main_pol"
      t.integer  "grade"
      t.float    "pm25"
      t.float    "pm10"
      t.float    "SO2"
      t.float    "CO"
      t.float    "NO2"
      t.float    "O3"
      t.float    "VIS"

      t.timestamps

      t.timestamps
    end

    add_index(:forecast_real_data, [:city_id, :publish_datetime, :forecast_datetime], unique: true, name: 'index_real_forecast_aqi_city_pubtime_foretime')
  end
end
