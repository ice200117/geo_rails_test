json.array!(@city_hours) do |city_hour|
  json.extract! city_hour, :id, :city_id_id, :pm25, :pm10, :o3, :o3_8h, :co, :so2, :no2, :aqi
  json.url city_hour_url(city_hour, format: :json)
end
