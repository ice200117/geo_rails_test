class HourlyCityForecastAirQuality < ActiveRecord::Base
  belongs_to :city

  def city_forecast(pinyin)
    cf = Hash.new
    hf = []
    puts pinyin
    c = City.find_by city_name_pinyin: pinyin
    return nil unless c
    ac = c.hourly_city_forecast_air_qualities.last(120)
    #puts ac.first
    return nil unless ac.first
    cf[:city_name] = c.city_name
    cf[:publish_datetime] = ac.first.publish_datetime.strftime('%Y-%m-%d_%H')
    ac.each do |ch|
      #if ch.forecast_datetime > Time.now
      ch.AQI = (ch.AQI**2 *0.0004 + 0.3314*ch.AQI + 18.231).round if pinyin=='taiyuanshi'
      hf << {forecast_datetime: ch.forecast_datetime.strftime('%Y-%m-%d_%H'), 
             AQI: ch.AQI, 
             main_pol: ch.main_pol, 
             grade: ch.grade,
             pm2_5: ch.pm25,
             pm10: ch.pm10,
             SO2: ch.SO2,
             CO: ch.CO,
             NO2: ch.NO2,
             O3: ch.O3,
             VIS: ch.VIS }
      #end
    end
    cf[:forecast_data] = hf
    return cf
  end
end
