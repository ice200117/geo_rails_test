class AddCityIdToCounty < ActiveRecord::Migration
  def change
    add_reference(:counties, :city, index: true)
  end
end
