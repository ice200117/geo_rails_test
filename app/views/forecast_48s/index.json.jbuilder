json.array!(@forecast_48s) do |forecast_48|
  json.extract! forecast_48, :id, :station_id_id, :pattern, :publish_time, :predict_time, :pm25, :pm10, :o3, :o3_8h, :co, :so2, :no2, :aqi
  json.url forecast_48_url(forecast_48, format: :json)
end
