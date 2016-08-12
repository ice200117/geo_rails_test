json.array!(@forecast_24s) do |forecast_24|
  json.extract! forecast_24, :id, :station_id_id, :pattern, :publish_time, :predict_time, :pm25, :pm10, :o3, :o3_8h, :co, :so2, :no2, :aqi
  json.url forecast_24_url(forecast_24, format: :json)
end
