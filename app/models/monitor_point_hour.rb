class MonitorPointHour < ActiveRecord::Base
	belongs_to :monitor_point
	belongs_to :city
	# validates_uniqueness_of :monitor_point_id, :scope => :data_real_time
	validates :monitor_point_id, uniqueness: { scope: :data_real_time,message: "数据重复！" }
	def last_hour_by_cityid(cityid)
		if Custom::Redis.get('qhd_hour').nil?
			tmp=MonitorPointHour.where(city_id: cityid).last.data_real_time
			stime=tmp.beginning_of_hour
			etime=tmp.end_of_hour
			Custom::Redis.set('qhd_hour',City.find(cityid).monitor_point_hours.where("data_real_time >= ? AND data_real_time <=?",stime,etime))
		else
			Custom::Redis.get('qhd_hour')
		end
	end

	#重写保存(参数类型为哈希)
	def save_with_arg(d)
		return 'id or time is nil' if d['id'] == nil || d['time'] == nil
		linedata=MonitorPointHour.find_or_create_by(monitor_point_id:d['id'],data_real_time: (d['time'].to_time.beginning_of_hour..d['time'].to_time.end_of_hour))
		linedata.data_real_time = d['time']
		linedata.city_id = d['city_id'] if !d['city_id'].nil?
		linedata.AQI = d['aqi'] if !d['aqi'].nil?
		linedata.SO2 = d['so2'] if !d['so2'].nil?
		linedata.NO2 = d['no2'] if !d['no2'].nil?
		linedata.CO = d['co'] if !d['co'].nil?
		linedata.pm10 = d['pm10'] if !d['pm10'].nil?
		linedata.pm25 = d['pm25'] if !d['pm25'].nil?
		linedata.pm25 = d['pm25'] if !d['pm2_5'].nil?
		linedata.O3 = d['o3'] if !d['o3'].nil?
		linedata.O3_8h = d['o3_8h'] if !d['o3_8h'].nil?
		linedata.quality = d['quality'] if !d['quality'].nil?
		linedata.level = d['level'] if !d['level'].nil?
		linedata.main_pol = d['main_pol'] if !d['main_pol'].nil?
		linedata.main_pol = d['main_pol'] if !d['main_pollutant'].nil?
		linedata.weather = d['weather'] if !d['weather'].nil?
		linedata.temp = d['temp'] if !d['temp'].nil?
		linedata.humi = d['humi'] if !d['humi'].nil?
		linedata.winddirection = d['winddirection'] if !d['winddirection'].nil?
		linedata.windspeed = d['windspeed'] if !d['windspeed'].nil?
		linedata.windscale = d['windscale'] if !d['windscale'].nil?
		if !d['so2'].nil? && !d['no2'].nil?&&!d['co'].nil?&&!d['pm10'].nil?&&!d['pm25'].nil?&&!d['o3_8h'].nil?
			linedata.zonghezhishu = d['so2'].to_f/60+d['no2'].to_f/40+d['pm10'].to_f/70+d['pm25'].to_f/35+d['co'].to_f/4+d['o3_8h'].to_f/160 
		end
		#计算同期对比
		sql_str=Array.new
		sql_str<<'data_real_time >= ? AND data_real_time <= ? AND city_id = ?'
		sql_str<<d['time'].to_time.years_ago(1).beginning_of_day
		sql_str<<d['time'].to_time.years_ago(1).end_of_day
		sql_str<<d['id']
		last_years_data = MonitorPointHour.where(sql_str)	
		if last_years_data.length != 0
			last_years=last_years_data[0]
			if !d['so2'].nil? && !last_years.SO2.nil?
				linedata.SO2_change_rate=(d['so2']-last_years.SO2)/last_years.SO2
			end
			if !d['no2'].nil? && !last_years.NO2.nil?
				linedata.NO2_change_rate=(d['no2']-last_years.NO2)/last_years.NO2
			end
			if !d['pm10'].nil? && !last_years.pm10.nil?
				linedata.pm10_change_rate=(d['pm10']-last_years.pm10)/last_years.pm10
			end
			if !d['pm25'].nil?&& !last_years.pm25.nil?
				linedata.pm25_change_rate=(d['pm25']-last_years.pm25)/last_years.pm25
			end
			if !d['co'].nil? && !last_years.CO.nil?
				linedata.CO_change_rate=(d['co']-last_years.CO)/last_years.CO
			end
			if !d['o3_8h'].nil? && !last_years.O3.nil?
				linedata.O3_8h_change_rate=(d['o3_8h']-last_years.O3)/last_years.O3
			end
			if !linedata.zonghezhishu.nil? && !last_years.zonghezhishu.nil?
				linedata.zongheindex_change_rate=(linedata.zonghezhishu-last_years.zonghezhishu)/last_years.zonghezhishu
			end
		end
		# linedata.save
		puts d['time'].to_s+' '+d['pointname']+' Save OK!'
		# end
	end

	def self.all_site(stime,etime)
		data = MonitorPointHour.where(data_real_time: (stime..etime))
		return nil if data[0]
		mp = MonitorPoint.all
		city = City.all
		mp.map do |m|
			l = {m.id => m}
			m = l
		end
		city.map do |c|
			l = {c.id => c}
			c = l
		end
		data.map do |l|
			c = city[l.city_id]
			m = mp[l.monitor_point_id]
			l['city_name'] = c['city_name']
			l['city_name_pinyin'] = c['city_name_pinyin']
			l['region']=m.region
			l['pointname']=m.pointname
			l['latitude']=m.latitude
			l['longitude']=m.longitude
		end
		data
	end
end
