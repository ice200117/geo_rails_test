class RemoveLatitudeFromForecastPoints < ActiveRecord::Migration
  def change
    remove_column :forecast_points, :longitude, :float
    remove_column :forecast_points, :latitude, :float
    add_column :forecast_points, :latlon, :point, :geographic => true
  end
end
