class AddUniqueIndexToHourlyCityForecastAirQualities < ActiveRecord::Migration
  def change
    add_index(:hourly_city_forecast_air_qualities, [:city_id, :publish_datetime, :forecast_datetime], unique: true, name: 'index_hourlyaqi_city_pubtime_foretime')
  end
end
