class AddInColumnsInHourlyForecast < ActiveRecord::Migration
  def change
    add_column :hourly_city_forecast_air_qualities,:ps,:float
    add_column :hourly_city_forecast_air_qualities,:tg,:float
    add_column :hourly_city_forecast_air_qualities,:rc,:float
    add_column :hourly_city_forecast_air_qualities,:rn,:float
    add_column :hourly_city_forecast_air_qualities,:ttp,:float
    add_column :hourly_city_forecast_air_qualities,:ter,:float
    add_column :hourly_city_forecast_air_qualities,:xmf,:float
    add_column :hourly_city_forecast_air_qualities,:dmf,:float
    add_column :hourly_city_forecast_air_qualities,:cor,:float
    add_column :hourly_city_forecast_air_qualities,:xlat,:float
    add_column :hourly_city_forecast_air_qualities,:xlon,:float
    add_column :hourly_city_forecast_air_qualities,:lu,:float
    add_column :hourly_city_forecast_air_qualities,:pbln,:float
    add_column :hourly_city_forecast_air_qualities,:pblr,:float
    add_column :hourly_city_forecast_air_qualities,:shf,:float
    add_column :hourly_city_forecast_air_qualities,:lhf,:float
    add_column :hourly_city_forecast_air_qualities,:ust,:float
    add_column :hourly_city_forecast_air_qualities,:swd,:float
    add_column :hourly_city_forecast_air_qualities,:lwd,:float
    add_column :hourly_city_forecast_air_qualities,:swo,:float
    add_column :hourly_city_forecast_air_qualities,:lwo,:float
    add_column :hourly_city_forecast_air_qualities,:t2m,:float
    add_column :hourly_city_forecast_air_qualities,:q2m,:float
    add_column :hourly_city_forecast_air_qualities,:u10,:float
    add_column :hourly_city_forecast_air_qualities,:v10,:float
    add_column :hourly_city_forecast_air_qualities,:wd,:float
    add_column :hourly_city_forecast_air_qualities,:ws,:float
    add_column :hourly_city_forecast_air_qualities,:pslv,:float
    add_column :hourly_city_forecast_air_qualities,:pwat,:float
    add_column :hourly_city_forecast_air_qualities,:clfrlo,:float
    add_column :hourly_city_forecast_air_qualities,:clfrmi,:float
    add_column :hourly_city_forecast_air_qualities,:clfrhi,:float
  end
end
