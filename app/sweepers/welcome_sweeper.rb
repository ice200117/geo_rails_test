class WelcomeSweeper < ApplicationController::Caching::Sweeper
  observe ChinaCitiesHour, HourlyCityForecastAirQuality

  def after_save(record)
    expire_page action: 'bar'
    expire_page action: 'pinggu'
  end
end
