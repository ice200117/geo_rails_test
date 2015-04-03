class RemoveLongtitudeFromCities < ActiveRecord::Migration
  def change
    remove_column :cities, :longtitude, :float
    add_column :cities, :longitude, :float
  end
end
