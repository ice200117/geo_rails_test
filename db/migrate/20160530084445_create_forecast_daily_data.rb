class CreateForecastDailyData < ActiveRecord::Migration
  def self.up
    create_table :forecast_daily_data do |t|
      t.references :city
      t.date :publish_date
      t.date :forecast_date
      t.integer :max_forecast
      t.integer :min_forecast
      t.string :main_pollutant
      
      t.timestamps
    end
  end

  def self.down
    drop_table :forecast_daily_data
  end
end
