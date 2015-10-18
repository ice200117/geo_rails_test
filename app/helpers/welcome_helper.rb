module WelcomeHelper
	def banner
		hs = Hash.new
		# monitor data
		md = hb_real
		hs[:rt]= md[:time]
		md[:cities].each do |c|
			if c['city'] == '保定'
				puts c
				hs = hs.merge(c)
				break
			end
		end
		# forecast data
		aqis = []
		pri_pol = []
		c = City.find_by_city_name_pinyin('baodingshi')
		ch = c.hourly_city_forecast_air_qualities.last(120).group_by_day(&:forecast_datetime)
		ch.each do |time,fds|
			t = Time.now
			if time > Time.local(t.year,t.month,t.day)
				#if time >= Time.local(2015,4,24)
				sum = []
				fds.each do |fd|
					sum << fd.AQI
				end
				aqis << [sum.min, sum.max]
				pri_pol << fds[0].main_pol
			end
		end

		lev_hs = {"you"=>"优", "yellow"=>"良", "qingdu"=>"轻度", "zhong"=>"中度","zhongdu"=>"重度", "yanzhong"=>"严重"}

		hs[:lev] = get_lev(hs[:aqi])
		hs[:lev_han] = lev_hs[hs[:lev]]

		#实时天气预报
		begin
			response = HTTParty.get('http://www.weather.com.cn/adat/sk/101090201.html')	
			json_data = JSON.parse(response.body)
			hs = hs.merge(json_data['weatherinfo'])	
		rescue
			hs[:real_time_weather] = false	
		end

		return hs
	end 

	def get_lev(a)
		if (0 .. 50) === a
			lev = 'you'
		elsif (50 .. 100) === a
			lev = 'yellow'
		elsif (100 .. 150) === a
			lev = 'qingdu'
		elsif (150 .. 200) === a
			lev = 'zhong'
		elsif (200 .. 300) === a
			lev = 'zhongdu'
		elsif (300 .. 500) === a
			lev = 'yanzhong'
		end
	end

	def hb_real
		hs = Hash.new
		begin
			response = HTTParty.get('http://www.izhenqi.cn/api/getdata_cityrank.php?secret=CHINARANK&type=HOUR&key='+Digest::MD5.hexdigest('CHINARANKHOUR'))
			d = JSON.parse(response.body)
			hs[:time] = (d['time']).to_time
			hs[:cities] =  d['rows']
		rescue
			puts 'Can not get data from izhenqi, please check network!'
		end
		hs
	end
end
