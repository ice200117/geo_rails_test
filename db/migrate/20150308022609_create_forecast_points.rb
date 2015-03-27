class CreateForecastPoints < ActiveRecord::Migration
  def change
    create_table :forecast_points do |t|
      t.float :longitude
      t.float :latitude
      t.datetime :publish_date
      t.datetime :forecast_date
      t.float :pm25
      t.float :pm10
      t.float :SO2
      t.float :CO
      t.float :NO2
      t.float :O3
      t.float :AQI
      t.float :VIS

      t.timestamps
    end
  end
end
