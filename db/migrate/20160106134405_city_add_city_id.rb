class CityAddCityId < ActiveRecord::Migration
  def change
	  add_column :cities,:cityid,:integer
  end
end
