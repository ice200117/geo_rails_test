class ForecastRealDatum < ActiveRecord::Base
  belongs_to :city

  def self.city_forecast_by_pinyin(pinyin)
    c = City.find_by_city_name_pinyin(pinyin)
    return nil unless c
    city_forecast(c)
  end


  def self.city_forecast_by_id(cityid)
  	c = City.find_by_cityid(cityid)
  	return nil unless c
  	self.city_forecast(c)
  end

  def self.city_forecast(c)
    firstime = true
    cf = Hash.new
    hf = []
    c.forecast_real_data.each do |ch|
      if firstime
        cf[:city_name] = c.city_name
        cf[:publish_datetime] = ch.publish_datetime.strftime('%Y-%m-%d_%H')
        firstime = false
      end

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
             VIS: ch.VIS,
             press:   ch.ps.round,
             rain:  ch.ttp.round,
             pblh: ch.pbln.round,
             t:  ch.t2m.round(1),
             rh:  ch.q2m.round,
             windDir:   ch.wd.round,
             windSpeed:   ch.ws.round(1) }
    end

    cf[:forecast_data] = hf
    return cf
  end

  def self.all_cities
    achf = []
    City.where("id < 388").includes(:forecast_real_data).each do |c|
      puts c.city_name
      firstime = true
      cf = Hash.new
      hf = []
      c.forecast_real_data.each do |ch|
        if firstime
          cf[:city_name] = c.city_name
          cf[:publish_datetime] = ch.publish_datetime.strftime('%Y-%m-%d_%H')
          firstime = false
        end

        #if ch.forecast_datetime > Time.now
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
               VIS: ch.VIS ,
               press:   ch.ps.round,
               rain:  ch.ttp.round,
               pblh: ch.pbln.round,
               t:  ch.t2m.round(1),
               rh:  ch.q2m.round,
               windDir:   ch.wd.round,
               windSpeed:   ch.ws.round(1) }
      end

      if hf.length > 0
        cf[:forecast_data] = hf
        achf << cf
      end
    end

    achf
  end

  #未来五天城市预报
  def air_quality_forecast(pinyin)
    if $redis[pinyin].nil?
      tmp = City.find_by_city_name_pinyin(pinyin).forecast_real_data.last(120).group_by_day(&:forecast_datetime)
      Custom::Redis.set(pinyin,tmp,3600)
    else
      tmp=Custom::Redis.get(pinyin)
    end

    fore_data = Hash.new
    tmp.each do |time,data|
      temp = Hash.new
      sum = 0
      num = 0
      tmpd = Hash.new

      ary = Array.new
      data.each do |t|
        sum += t['AQI'];num += 1 if t['AQI'] != 0
        ary << t['AQI']
        td = false
        if tmpd[t['main_pol']] == nil
          tmpd[t['main_pol']] = 1
        else
          tmpd[t['main_pol']] += 1
        end
      end

      #temp['max'] = ary.max
      #temp['min'] = ary.min

      temp["main_pol"]=tmpd.sort{|a,b| a[1] <=> b[1]}.last.first.to_s
      temp["AQI"] = (sum/num).round
      temp['max'] = temp["AQI"]+10
      temp['min'] = temp["AQI"]-10
      temp["level"] = get_lev(temp['min'])
      temp["level1"] = get_lev(temp['max'])
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
			#cs = City.wwGGD5m3here("id < 388")
			#cs.each do |c|
			#city_avg[c.city_name] = city_avg_today(c,spe)
			#end

			# Sencond method
			nowday = Time.zone.now
			cs = City.includes(:forecast_real_data).where(forecast_real_data: {publish_datetime: 5.days.ago.beginning_of_day..nowday.end_of_day, forecast_datetime: nowday.beginning_of_day..nowday}).order("forecast_real_data.publish_datetime")
			cs.each do |cl|
				fs = cl.forecast_real_data
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
		fs = city.forecast_real_data.order(:publish_datetime).last(120)

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
end
