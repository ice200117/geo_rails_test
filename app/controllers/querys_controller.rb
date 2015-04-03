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

  def all_cities
    achf = []
    ac = City.pluck(:city_name_pinyin)
    h = HourlyCityForecastAirQuality.new
    ac.each do |c|
      ch = h.city_forecast(c) 
      achf << ch if ch
    end

    render json: achf
  end

  def all_cities_for_map
  end
end
