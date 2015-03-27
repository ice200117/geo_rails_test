class AddLatitudeFromForecastPoints < ActiveRecord::Migration
  def change
    add_column :forecast_points, :longitude, :float
    add_column :forecast_points, :latitude, :float
  end
end
