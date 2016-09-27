class CreateCityHours < ActiveRecord::Migration
  def change
    create_table :city_hours do |t|
      t.references :city, index: true
      t.float :pm25
      t.float :pm10
      t.float :o3
      t.float :o3_8h
      t.float :co
      t.float :so2
      t.float :no2
      t.float :aqi

      t.timestamps
    end
  end
end
