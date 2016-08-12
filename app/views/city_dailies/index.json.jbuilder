json.array!(@city_dailies) do |city_daily|
  json.extract! city_daily, :id, :city_id_id, :publish_time, :pm25, :pm10, :o3, :o3_8h, :co, :so2, :no2, :aqi
  json.url city_daily_url(city_daily, format: :json)
end
