json.array!(@forecast_96s) do |forecast_96|
  json.extract! forecast_96, :id, :station_id_id, :pattern, :publish_time, :predict_time, :pm25, :pm10, :o3, :o3_8h, :co, :so2, :no2, :aqi
  json.url forecast_96_url(forecast_96, format: :json)
end
