#全国实时天气
module Weather
	class Weather
		#默认北京
		def initialize(citykey = "101010100")
			@citykey = citykey
		end
		#获取初始化城市所有数据
		def all_weather_info_of_city
			begin
				response = HTTParty.get('http://wthrcdn.etouch.cn/WeatherApi?citykey='+@citykey.to_s)
				data = Hash.from_xml(response.body)
			rescue
				return nil
			end
		end
	end
end
