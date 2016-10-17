class AddCityRefToEnterprise < ActiveRecord::Migration
  def change
    add_reference :enterprises, :city, index: true
  end
end
