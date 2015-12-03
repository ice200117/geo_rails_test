class HourlyCityForecastAirQuality < ActiveRecord::Base
	belongs_to :city

	def city_forecast(pinyin)
		cf = Hash.new
		hf = []
		puts pinyin
		c = City.find_by city_name_pinyin: pinyin
		return nil unless c
		ac = c.hourly_city_forecast_air_qualities.last(120)
		#puts ac.first
		return nil unless ac.first
		cf[:city_name] = c.city_name
		cf[:publish_datetime] = ac.first.publish_datetime.strftime('%Y-%m-%d_%H')
		#    cf[:update_time] = Time.now.strftime('%Y-%m-%d_%H')
		ac.each do |ch|
			#if ch.forecast_datetime > Time.now
			#      ch.AQI = (ch.AQI**2 *0.0004 + 0.3314*ch.AQI - 32.231).round if pinyin=='taiyuanshi'
			#      ch.AQI = ch.AQI*2.51 #if pinyin=='langfangshi'
			hf << {forecast_datetime: ch.forecast_datetime.strftime('%Y-%m-%d_%H'), 
		  AQI: ch.AQI.round, 
		  main_pol: ch.main_pol, 
		  grade: ch.grade,
		  pm2_5: ch.pm25,
		  pm10: ch.pm10,
		  SO2: ch.SO2,
		  CO: ch.CO,
		  NO2: ch.NO2,
		  O3: ch.O3,
		  VIS: ch.VIS }
			#end
		end
		cf[:forecast_data] = hf
		return cf
	end

	#未来五天城市预报
	def air_quality_forecast(pinyin)
		tmp = City.find_by_city_name_pinyin(pinyin).hourly_city_forecast_air_qualities.last(120).group_by_day(&:forecast_datetime)
		fore_data = Hash.new
		tmp.each do |time,data|
			temp = Hash.new 
			sum = 0
			num = 0
			tmpd = Hash.new
			data.each do |t|
				sum += t.AQI;num += 1 if t.AQI != 0
				td = false
				if tmpd[t.main_pol] == nil
					tmpd[t.main_pol] = 1
				else
					tmpd[t.main_pol] += 1
				end
			end
			temp["main_pol"]=tmpd.sort{|a,b| a[1] <=> b[1]}.last.first.to_s
			temp["AQI"] = sum/num
			temp["level"] = get_lev(sum/num)
			fore_data[time] = temp
		end
		fore_data
	end

	#aqi等级
	def get_lev(a)
		if (0 .. 50) === a
			lev = '优'
		elsif (50 .. 100) === a
			lev = '良'
		elsif (100 .. 150) === a
			lev = '轻度污染'
		elsif (150 .. 200) === a
			lev = '中度污染'
		elsif (200 .. 300) === a
			lev = '重度污染'
		elsif (300 .. 500) === a
			lev = '严重污染'
		end
	end

	def self.today_avg(city_name_pinyin=nil,spe="AQI")
		city_avg = {}
		if city_name_pinyin
			c = City.find_by_city_name_pinyin(city_name_pinyin)

			
			city_avg[c.city_name] = city_avg_today(c,spe) if c
		else
			#cs = City.includes(:china_cities_hours)
			cs = City.where("id < 388")
			cs.each do |c|
				city_avg[c.city_name] = city_avg_today(c,spe)
			end
		end
		city_avg
	end

	def self.city_avg_today(city=nil,spe="AQI")
		return nil unless city
		fs = city.hourly_city_forecast_air_qualities.last(120)

		aqi_sum = 0
		i = 0
		fs.each do |f|
			if f.forecast_datetime >= Time.zone.now.beginning_of_day and f.forecast_datetime <= Time.zone.now
				aqi_sum += f.AQI
				i += 1
			end
		end

		{fs[0].publish_datetime.strftime("%Y-%m-%d_%H") => (aqi_sum/i).round } if i > 0
	end
end
