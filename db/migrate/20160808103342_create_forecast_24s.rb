class CreateForecast24s < ActiveRecord::Migration
  def change
    create_table :forecast_24s do |t|
      t.references :station, index: true
      t.string :pattern
      t.date :publish_time
      t.date :predict_time
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
