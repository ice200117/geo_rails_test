class HourlyCityForecastAirQuality < Partitioned::ByMonthlyTimeField
  belongs_to :city

  def self.partition_time_field
    return :publish_datetime
  end

  partitioned do |partition|
    partition.index :id, :unique => true
    partition.index [:city_id, :publish_datetime, :forecast_datetime], :unique => true
    partition.foreign_key :city_id
  end

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
             VIS: ch.VIS ,
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

  #未来五天城市预报
  def air_quality_forecast(pinyin)
    unless Custom::Redis.get(pinyin)
      tmp = City.find_by_city_name_pinyin(pinyin).hourly_city_forecast_air_qualities.order(:publish_datetime).last(120).group_by_day(&:forecast_datetime)
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

      temp['max'] = ary.max
      temp['min'] = ary.min

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
      #cs = City.wwGGD5m3here("id < 388")
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

    tmp1 = []
    tmp2 = []
    tmp3 = []
    tmp4 = []
    data.each do |d|
      if d.forecast_datetime >= d.publish_datetime+12.hours and d.forecast_datetime < d.publish_datetime+36.hours
        unless tmp1.include? d.forecast_datetime
          fore_data_24 << [d.forecast_datetime, d.AQI]
          tmp1 << d.forecast_datetime
        end
      elsif d.forecast_datetime >= d.publish_datetime+36.hours and d.forecast_datetime < d.publish_datetime+60.hours
        unless tmp2.include? d.forecast_datetime
          fore_data_48 << [d.forecast_datetime, d.AQI]
          tmp2 << d.forecast_datetime
        end
      elsif d.forecast_datetime >= d.publish_datetime+60.hours and d.forecast_datetime < d.publish_datetime+84.hours
        unless tmp3.include? d.forecast_datetime
          fore_data_72 << [d.forecast_datetime, d.AQI]
          tmp3 << d.forecast_datetime
        end
      elsif d.forecast_datetime >= d.publish_datetime+84.hours and d.forecast_datetime < d.publish_datetime+108.hours
        unless tmp4.include? d.forecast_datetime
          fore_data_96 << [d.forecast_datetime, d.AQI]
          tmp4 << d.forecast_datetime
        end
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
  #指定五天城市预报
  def forecast_24h(pinyin,stime,etime)
    unless Custom::Redis.get(pinyin+stime.to_s+etime.to_s)
      tmp = City.find_by_city_name_pinyin(pinyin).hourly_city_forecast_air_qualities.where(publish_datetime:(stime.to_time.yesterday.beginning_of_day..etime.to_time.yesterday.end_of_day)).to_a.group_by_day(&:publish_datetime)
      return nil if tmp.size == 0
      tmp.each do |k,v|
        v.delete_if{|x| !((k.tomorrow.beginning_of_day.to_f..k.tomorrow.end_of_day.to_f) === x.forecast_datetime.to_f)}
      end
      tmp1 = {}
      tmp.keys.each{|x| tmp1[x.to_date+1] = tmp[x];tmp.delete(x)}
      tmp = tmp1
      Custom::Redis.set(pinyin+stime.to_s+etime.to_s,tmp,3600)
    else 
      tmp=Custom::Redis.get(pinyin+stime.to_s+etime.to_s)
    end
    tmp.each do |k,v|
      six = {'SO2'=>[],'NO2'=>[],'pm10'=>[],'pm25'=>[],'CO'=>[],'O3'=>[]}
      v.each do |l|
        six.keys.each{|x| six[x] << l[x].to_f}
      end
      six.each do |m,n|
        if m == 'O3'
          j = []
          (0..16).each do |a|
            j << n[a..a+7].sum
          end
          six[m] = j.max/8
        else
          (n.sum == 0 or n.size == 0) ? six[m] = 0 : six[m] = n.sum/n.size 
        end
      end
      six['zhzs'] = six['SO2'].to_f.round(2)/60+six['NO2'].to_f.round(2)/40+six['pm10'].to_f.round(2)/70+six['pm25'].to_f.round(2)/35+six['CO'].to_f.round(2)/4+six['O3'].to_f.round(2)/160
      six['aqi'] = get_aqi(six)['aqi']
      tmp[k] = six
    end
    tmp
  end

	def get_aqi(data)
		#data为hash值eg:data={'so2'=>1,'no2'=>1,'pm10'=>1,'pm25'=>1,'co'=>1,'o3_8h'=>1}
		#返回值为aqi和首要污染物return {'aqi'=>1,'main_poll'=>O3}
		init=Hash.new
		init['iaqi']={0=>0,1=>50,2=>100,3=>150,4=>200,5=>300,6=>400,7=>500}
		init['SO2']=[0,50,150,475,800,1600,2100,2620]
		init['NO2']=[0,40,80,180,280,565,750,940]
		init['pm10']=[0,50,150,250,350,420,500,600]
		init['CO']=[0,2,4,14,24,36,48,60]
		init['O3']=[0,100,160,215,265,800]
		init['pm25']=[0,35,75,115,150,250,350,500]
		init['subindex'] = []
		data.each do |k,v|
			next if init[k].nil? || v.nil?
			# return false if init[k][-1] < v || v.nil? #超过最大值返回false
			if init[k][-1] < v 
				init['subindex'] << { 'iaqi' => init['iaqi'][init[k].size-1],'name'=>k} 
				next
			end
			for i in (0..init[k].length-2)
				if init[k][i] < v && v < init[k][i+1]
					bpL = init[k][i]
					bpH = init[k][i+1]
					iaqiL = init['iaqi'][i]
					iaqiH = init['iaqi'][i+1]
					iaqi = (iaqiH-iaqiL)/(bpH-bpL).to_f*(v-bpL)+iaqiL
					init['subindex'] << { 'iaqi'=>iaqi,'name'=>k}
					break
				elsif init[k][i] == v
					init['subindex'] << { 'iaqi' => init['iaqi'][i],'name'=>k} 
					break
				elsif init[k][i+1] == v
					init['subindex'] << { 'iaqi' => init['iaqi'][i+1],'name'=>k}
					break
				end
			end	
		end
		if init['subindex'].size == 0
			aqi = nil
			main_poll = nil
		else
			init['subindex'] = init['subindex'].group_by{|x| x['iaqi']} #由分指数进行分组
			aqi=init['subindex'].keys.max #求出最大分指数分组
			main_poll = ''
			init['subindex'][aqi].each do |l|
				l['name'] = 'PM2.5' if l['name'] == 'pm25'
				main_poll = main_poll+l['name'].upcase+','
			end
			main_poll.chop!
		end
		{'aqi'=>aqi,'main_poll'=>main_poll}
	end
end
