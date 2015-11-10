require_relative './city_enum.rb'
def get_monitor(id,time)
	model = get_model_by_id(id)
	return "city not find" if model == nil
	stime = time.beginning_of_hour
	etime = time.end_of_hour
	sql = Array.new
	sql << "data_real_time >= ? and data_real_time <= ? and id = ?"
	sql << stime
	sql << etime
	sql << id
	data_ary = model.where(sql)
	data_ary[0]
end

def get_forecast(stime,etime)
	stime = stime.beginning_of_hour
	etime = etime.end_of_hour
	sql = Array.new
	sql << "data_real_time => ? and data_real_time =< ?"
	sql << stime
	sql << etime
	data_ary = HourlyCityForecastAirQuality.where(sql)
	data_ary[0]
end

def get_model_by_name(city_name)
	model = false
	if CityEnum.baoding.include?(city_name)
		model = TempBdHour
	elsif CityEnum.langfang.include?(city_name)
		model = TempLfHour
	elsif CityEnum.jjj.include?(city_name)
		model = TempHbHour
	elsif CityEnum.china_city_74.include?(city_name)
		model = TempSfcitiesHour
	end
	model ? model : nil
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
