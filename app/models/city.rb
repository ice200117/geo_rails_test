class City < ActiveRecord::Base
  before_save       :setLonLat
  has_many :hourly_city_forecast_air_qualities
  has_many :temp_hourly_forecasts
  has_many :day_cities
  has_many :monitor_points
  has_many :china_cities_hours
  has_many :weather_hours
  has_many :weather_forecasts
  has_many :weather_days
  has_many :monitor_point_hours
  has_many :monitor_point_days
  has_many :monitor_point_months
  has_many :monitor_point_years
  has_many :ann_forecast_data, :class_name => 'AnnForecastData'
  has_many :forecast_real_data
  has_many :forecast_daily_data
  has_many :temp_sfcities_hours
  has_many :temp_sfcities_days
  has_many :temp_sfcities_months
  has_many :temp_sfcities_years
  
#  validates_uniqueness_of :post_number

  set_rgeo_factory_for_column(:lonlat,
    RGeo::Geographic.spherical_factory(:srid => 4326))

  def setLonLat
    self.lonlat = "POINT(#{longitude} #{latitude})"
  end

end
