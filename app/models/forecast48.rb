class Forecast48 < ActiveRecord::Base
  self.table_name = 'forecast_48s'
  belongs_to :station, class_name: "City", foreign_key: "station_id"
end
