json.array!(@forecast_points) do |forecast_point|
  json.extract! forecast_point, :id, :longitude, :latitude, :publish_date, :forecast_date, :pm25, :pm10, :SO2, :CO, :NO2, :O3, :AQI, :VIS
  json.url forecast_point_url(forecast_point, format: :json)
end
