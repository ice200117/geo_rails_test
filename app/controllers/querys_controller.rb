class QuerysController < ApplicationController

  def aqis_by_city
    pinyin = params[:city]
    h = HourlyCityForecastAirQuality.new
    chf = h.city_forecast(pinyin)
    render json: chf
  end

  def cities
    cs = City.pluck(:city_name, :city_name_pinyin)
    render json: cs
  end

  def all_cities2
    achf = []
    ac = City.pluck(:city_name_pinyin)
    h = HourlyCityForecastAirQuality.new
    ac.each do |c|
      ch = h.city_forecast(c) 
      achf << ch if ch
    end

    render json: achf
  end

  def all_cities
    achf = []
    cs = City.includes(:hourly_city_forecast_air_qualities)
    cs.each do |c|
      cf = Hash.new
      hf = []
      #hs = c.hourly_city_forecast_air_qualities.order(publish_datetime: :desc).limit(120).where("forecast_datetime > ?", Time.now)
      hs = c.hourly_city_forecast_air_qualities.last(120)
      return nil unless hs.first
      cf[:city_name] = c.city_name
      cf[:publish_datetime] = hs.first.publish_datetime.strftime('%Y-%m-%d_%H')
      hs.each do |ch|
        if ch.forecast_datetime > Time.now
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
        end
      end
      cf[:forecast_data] = hf
      achf << cf
    end

    render json: achf
  end
end
