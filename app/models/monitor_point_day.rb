class MonitorPointDay < ActiveRecord::Base
	belongs_to:city
	belongs_to:monitor_point
	validates :monitor_point_id, uniqueness: { scope: :data_real_time,message: "数据重复！" }
	def yesterday_by_cityid(cityid)
		time_start=Time.now.yesterday.beginning_of_day
		time_end=Time.now.yesterday.end_of_day
		# MonitorPoint.find_by_city_id(cityid).monitor_point_hours.where("data_real_time >= ? AND data_real_time <=?",time_start,time_end)
		City.find(cityid).monitor_point_days.where("data_real_time >= ? AND data_real_time <=?",time_start,time_end)
	end
	#重写保存(参数类型为哈希)
	def save_with_arg(d)
		return 'id or time is nil' if d['id'] == nil || d['time'] == nil
		tmp = MonitorPointDay.where("monitor_point_id =? AND data_real_time >= ? AND data_real_time <= ?",d['id'], d['time'].beginning_of_day,d['time'].end_of_day)
		linedata=nil
		if tmp.length == 0
			linedata=MonitorPointDay.new
		else
			linedata=tmp[0]
		end
		linedata.monitor_point_id = d['id']
		linedata.data_real_time = d['time']
		linedata.city_id = d['city_id'] if !d['city_id'].nil?
		linedata.AQI = d['aqi'] if !d['aqi'].nil?
		linedata.SO2 = d['so2'] if !d['so2'].nil?
		linedata.NO2 = d['no2'] if !d['no2'].nil?
		linedata.CO = d['co'] if !d['co'].nil?
		linedata.pm10 = d['pm10'] if !d['pm10'].nil?
		linedata.pm25 = d['pm25'] if !d['pm25'].nil?
		linedata.O3 = d['o3'] if !d['o3'].nil?
		linedata.O3_8h = d['o3_8h'] if !d['o3_8h'].nil?
		linedata.quality = d['quality'] if !d['quality'].nil?
		linedata.level = d['level'] if !d['level'].nil?
		linedata.main_pol = d['main_pol'] if !d['main_pol'].nil?
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
		last_years_data = MonitorPointDay.where(sql_str)	
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
		linedata.save
		puts d['time'].to_s+' '+d['pointname'].to_s+' Save OK!'
		
	end
end
