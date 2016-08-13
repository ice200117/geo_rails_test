class ForecastDaily < ActiveRecord::Base
  belongs_to :station, class_name: "City", foreign_key: "station_id"
end
