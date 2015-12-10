require_relative './getdata/common.rb'

def set_change_rate
	flag='temp_bd_days'
	t=get_db_data(flag,'last','')
	t.zonghezhishu=get_zonghezhishu(flag)
	t.save
	puts '=='+flag+'=='+t.data_real_time.to_s+'=Save OK!=='
	t=get_db_data(flag,'last','')
	if t.data_real_time.year.to_i>2014 && change_rate=get_change_rate(flag,t.id,t.data_real_time)
		day_city.SO2_change_rate=change_rate[:SO2]
		day_city.NO2_change_rate=change_rate[:NO2]
		day_city.CO_change_rate=change_rate[:CO]
		day_city.O3_change_rate=change_rate[:O3]
		day_city.pm10_change_rate=change_rate[:pm10]
		day_city.pm25_change_rate=change_rate[:pm25]
		day_city.zongheindex_change_rate=change_rate[:zhzs]
	end
	t.save
	set_bd_month(t.data_real_time,t.city_id)
	set_bd_year(t.data_real_time,t.city_id)
end

def set_bd_month(time,id)
	flag='temp_bd_months'
	save_db(time,id,flag)
end
def set_bd_year(time,id)
	flag = 'temp_bd_years'
	save_db(time,id,flag)
end

def save_db(time,id,flag)
  
	day_city = get_db_data(flag,'new',nil)
	day_city.city_id=id
	case flag
	when 'temp_bd_months'
		t=Hash.new
		t=get_avg_by_month(flag,id,time)
	when 'temp_bd_years'
		t=Hash.new
		t=get_avg_by_year(flag,id,time)
	end
	day_city.SO2=t['so2']
	day_city.NO2=t['no2']
	day_city.CO=t['co']
	day_city.O3 = t['o3']
	day_city.pm10 = t['pm10']
	day_city.pm25 = t['pm2_5']
	day_city.data_real_time=time.to_time
	day_city.save
	day_city=get_db_data(flag,'last',nil)
	day_city.zonghezhishu=get_zonghezhishu(flag)
	day_city.save
	day_city=get_db_data(flag,'last',nil)
	if time.to_time.year.to_i>2014.to_i
		change_rate = get_change_rate(flag,id,time)
		return if change_rate == false
		day_city.SO2_change_rate = change_rate[:SO2]
		day_city.NO2_change_rate = change_rate[:NO2]
		day_city.CO_change_rate = change_rate[:CO]
		day_city.O3_change_rate = change_rate[:O3]
		day_city.pm10_change_rate = change_rate[:pm10]
		day_city.pm25_change_rate = change_rate[:pm25]
		day_city.zongheindex_change_rate = change_rate[:zhzs]
	end
	day_city.save
	puts '=='+flag+'=='+time.to_s+'=save OK!=='
end
