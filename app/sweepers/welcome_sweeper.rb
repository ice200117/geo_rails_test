class WelcomeSweeper < ActionController::Caching::Sweeper
  observe ChinaCitiesHour, HourlyCityForecastAirQuality

  def self.after_save(record)
    ApplicationController.expire_page(controller: 'welcome', action: 'bar')
    #expire_page action: 'pinggu'
  end
end
