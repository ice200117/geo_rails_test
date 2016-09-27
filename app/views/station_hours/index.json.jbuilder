json.array!(@station_hours) do |station_hour|
  json.extract! station_hour, :id, :station_id_id, :pm25, :pm10, :o3, :o3_8h, :co, :so2, :no2, :aqi
  json.url station_hour_url(station_hour, format: :json)
end
