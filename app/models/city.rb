class City < ActiveRecord::Base
  before_save       :setLonLat
  has_many :hourly_city_forecast_air_qualities
  has_many :day_cities
#  validates_uniqueness_of :post_number

  set_rgeo_factory_for_column(:lonlat,
    RGeo::Geographic.spherical_factory(:srid => 4326))

  def setLonLat
    self.lonlat = "POINT(#{longitude} #{latitude})"
  end

end
