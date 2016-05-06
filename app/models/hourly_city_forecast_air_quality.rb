class HourlyCityForecastAirQuality < ActiveRecord::Base
	belongs_to :city

	def city_forecast_by_id(cityid)
		c = City.find_by_cityid(cityid)
		return nil unless c
		city_forecast(c)
	end

	def city_forecast_by_pinyin(pinyin)
		c = City.find_by_city_name_pinyin(pinyin)
		return nil unless c
		city_forecast(c)
	end

	def city_forecast(c)
		cf = Hash.new
		hf = []
		ac = c.hourly_city_forecast_air_qualities.order(:publish_datetime).last(120)
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
		tmp = City.find_by_city_name_pinyin(pinyin).hourly_city_forecast_air_qualities.order(:publish_datetime).last(120).group_by_day(&:forecast_datetime)
		fore_data = Hash.new
		#puts tmp
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

	def self.today_avg(city_name_pinyin=nil,spe=:AQI)
		city_avg = {}
		if city_name_pinyin
			c = City.find_by_city_name_pinyin(city_name_pinyin)

			city_avg[c.city_name] = city_avg_today(c,spe) if c
		else
			# First method
			#cs = City.where("id < 388")
			#cs.each do |c|
			#city_avg[c.city_name] = city_avg_today(c,spe)
			#end

			# Sencond method
			nowday = Time.zone.now
			cs = City.includes(:hourly_city_forecast_air_qualities).where(hourly_city_forecast_air_qualities: {publish_datetime: 5.days.ago.beginning_of_day..nowday.end_of_day, forecast_datetime: nowday.beginning_of_day..nowday}).order("hourly_city_forecast_air_qualities.publish_datetime")
			cs.each do |cl|
				fs = cl.hourly_city_forecast_air_qualities
				latest_publish_datetime = fs.last.publish_datetime
				aqi_sum = 0; i = 0
				fs.each do |f|
					if f.publish_datetime == latest_publish_datetime
						aqi_sum += f.send(spe)
						i += 1
					end
				end
				city_avg[cl.city_name] = {latest_publish_datetime.strftime("%Y-%m-%d_%H") => (aqi_sum/i).round }
			end
		end
		city_avg
	end

	def self.city_avg_today(city=nil,spe=:AQI)
		return nil unless city
		fs = city.hourly_city_forecast_air_qualities.order(:publish_datetime).last(120)

		aqi_sum = 0
		i = 0
		fs.each do |f|
			if f.forecast_datetime >= Time.zone.now.beginning_of_day and f.forecast_datetime <= Time.zone.now
				aqi_sum += f.send(spe)
				i += 1
			end
		end
		i > 0 ? {fs[0].publish_datetime.strftime("%Y-%m-%d_%H") => (aqi_sum/i).round }   : nil

	end


  ## city : single obj query from city table
  #  start_time : data of starttime
  #  datascope : 0 contain all 24 hour data, 48 hour data, 72 hour data, 96 hour data.
  #              1 contain 24 hour data
  #              2 contain 48 hour data
  #              3 contain 72 hour data
  #              4 contain 96 hour data
  def self.history_data_hour(city=City.find(18), start_time=3.days.ago, data_scope=0)
    fore_data_24 = []
    fore_data_48 = []
    fore_data_72 = []
    fore_data_96 = []
    data =  city.hourly_city_forecast_air_qualities.where(publish_datetime: start_time..Time.now).order(:publish_datetime)
    
    data.each do |d|
      if d.forecast_datetime >= d.publish_datetime+12.hours and d.forecast_datetime < d.publish_datetime+36.hours
        fore_data_24 << [d.forecast_datetime, d.AQI]
      elsif d.forecast_datetime >= d.publish_datetime+36.hours and d.forecast_datetime < d.publish_datetime+60.hours
        fore_data_48 << [d.forecast_datetime, d.AQI]
      elsif d.forecast_datetime >= d.publish_datetime+60.hours and d.forecast_datetime < d.publish_datetime+84.hours
        fore_data_72 << [d.forecast_datetime, d.AQI]
      elsif d.forecast_datetime >= d.publish_datetime+84.hours and d.forecast_datetime < d.publish_datetime+108.hours
        fore_data_96 << [d.forecast_datetime, d.AQI]
      end
    end

    fore_data = []
    case data_scope
    when 0
      fore_data << fore_data_24
      fore_data << fore_data_48
      fore_data << fore_data_72
      fore_data << fore_data_96
    when 1
      fore_data_24
    when 2
      fore_data_48
    when 3
      fore_data_72
    when 4
      fore_data_96
    else
      fore_data
    end
  end
end
