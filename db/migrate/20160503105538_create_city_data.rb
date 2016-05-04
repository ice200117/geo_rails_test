class CreateCityData < ActiveRecord::Migration
  def change
    create_table :city_data do |t|

      t.timestamps
    end
  end
end
