class CreateHourlyCityForecastAirQualities < ActiveRecord::Migration
  def change
    create_table :hourly_city_forecast_air_qualities do |t|
      t.integer  :city_id          
      t.datetime :publish_datetime 
      t.datetime :forecast_datetime
      t.float    :AQI              
      t.string   :main_pol         
      t.integer  :grade            
      t.float    :pm25             
      t.float    :pm10             
      t.float    :SO2              
      t.float    :CO               
      t.float    :NO2              
      t.float    :O3               
      t.float    :VIS              

      t.timestamps
    end
  end
end
