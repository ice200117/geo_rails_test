class WelcomeSweeper < ActionController::Caching::Sweeper
  observe ChinaCitiesHour, HourlyCityForecastAirQuality

  def self.after_save(record)
    ApplicationController.expire_page("/bar")
    ApplicationController.expire_page("/")
    #expire_page action: 'pinggu'
  end
end
