json.array!(@station_dailies) do |station_daily|
  json.extract! station_daily, :id, :station_id_id, :publish_time, :pm25, :pm10, :o3, :o3_8h, :co, :so2, :no2, :aqi
  json.url station_daily_url(station_daily, format: :json)
end
