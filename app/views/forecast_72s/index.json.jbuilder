json.array!(@forecast_72s) do |forecast_72|
  json.extract! forecast_72, :id, :station_id_id, :pattern, :publish_time, :predict_time, :pm25, :pm10, :o3, :o3_8h, :co, :so2, :no2, :aqi
  json.url forecast_72_url(forecast_72, format: :json)
end
