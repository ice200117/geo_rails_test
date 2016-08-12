class CreateStationDailies < ActiveRecord::Migration
  def change
    create_table :station_dailies do |t|
      t.references :station_id, index: true
      t.date :publish_time
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
