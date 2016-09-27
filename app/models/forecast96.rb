class Forecast96 < ActiveRecord::Base
  belongs_to :station, class_name: "City", foreign_key: "station_id"
  self.table_name = 'forecast_96s'
end
