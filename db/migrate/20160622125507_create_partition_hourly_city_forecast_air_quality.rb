class CreatePartitionHourlyCityForecastAirQuality < ActiveRecord::Migration
   def up
    HourlyCityForecastAirQuality.create_infrastructure
  end

  def down
    HourlyCityForecastAirQuality.delete_infrastructure
  end
end
