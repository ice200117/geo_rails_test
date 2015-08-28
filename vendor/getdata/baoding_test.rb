require_relative './common.rb'

def main_get
	#保定小时数据
	flag = 'temp_bd_hours'
	hs=ten_times_test(flag,'shishi_rank_data','BAODINGRANK','DAY','')  
	if hs!=false
		save_db(hs,flag)
	end
end

def save_db(hs,flag) 
	hs[:cities].each do |t|
		city_array=City.where("city_name = ?",t['city'])
		city=city_array[0]
		day_city=get_db_data(flag,'new','')	
		day_city.city_id=city.id
		day_city.SO2=t['so2']
		day_city.NO2=t['no2']
		day_city.CO=t['co']
		t['o3'] == 0 ? day_city.O3 = t['o3_8h'] : day_city.O3 = t['o3']
		day_city.pm10=t['pm10']
		day_city.pm25=t['pm2_5']
		if !t['aqi'].nil?
			day_city.AQI=t['aqi']
		end
		if !t['quality'].nil?
			day_city.level=t['quality']
		end
		if !t['main_pollutant'].nil?
			day_city.main_pol=t['main_pollutant']
		end
		day_city.data_real_time=hs[:time].to_time
		day_city.save
		day_city=get_db_data(flag,'last','')
		day_city.zonghezhishu=get_zonghezhishu(flag)
		day_city.save
		puts '=================='+hs[:time]+'=Save OK!==============================='
	end
end
main_get
