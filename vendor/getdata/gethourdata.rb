require_relative './common.rb'

def main_get
	hs=Hash.new
	oneday=60*60*24

	#廊坊实时数据
	flag='temp_lf_hours'
	(0..5).each	do |t|
		hs=get_rank_json('shishi_rank_data','LANGFANGRANK','HOUR','')
		if hs != false
			break
		end
	end
	if hs==false
		puts 'Get temp_lf_hours error!'
	else
		if hs[:total]!='0' && hs[:time]>(Time.now-60*60).beginning_of_hour 
			save_db(hs,flag)	
		end	
	end

	#河北实时数据
	flag='temp_hb_hours'
	(0..5).each	do |t|
		hs=get_rank_json('shishi_rank_data','HEBEIRANK','HOUR','')
		if hs != false
			break
		end
	end
	if hs==false
		puts 'Get temp_hb_hours error!'
	else
		if hs[:total]!='0' && hs[:time]>(Time.now-60*60).beginning_of_hour 
			save_db(hs,flag)	
		end	
	end

	#74城市实时数据
	flag='temp_sfcities_hours'
	(0..5).each	do |t|
		hs=get_rank_json('shishi_rank_data','CHINARANK','HOUR','')
		if hs != false
			break
		end
	end
	if hs==false
		puts 'Get temp_74_hours error!'
	else
		if hs[:total]!='0' && hs[:time]>(Time.now-60*60).beginning_of_hour 
			save_db(hs,flag)	
		end	
	end
end 

#保存数据到day_city
def save_db(hs,flag) 
	hs[:cities].each do |t|
		if t['city']=='市辖区'
			t['city']='廊坊开发区'
		elsif t['city']=='大厂回族自治县'
			t['city']='大厂'
		end
		city_array = City.where("city_name like ?",t['city']+'_')
		if city_array.length==0
			city_array=City.where("city_name = ?",t['city'])
		end
		city=city_array[0]
		day_city=get_db_data(flag,'new','')	
		puts flag 
		day_city.city_id=city.id
		day_city.SO2=t['so2']
		day_city.NO2=t['no2']
		day_city.CO=t['co']
		day_city.O3=t['o3']
		day_city.pm10=t['pm10']
		day_city.pm25=t['pm2_5']
		day_city.AQI=t['aqi']
		day_city.quality=t['quality']
		day_city.main_pollutant=t['main_pollutant']
		day_city.weather=t['weather']
		day_city.temp=t['temp']
		day_city.humi=t['humi']
		day_city.winddirection=t['winddirection']
		day_city.windspeed=t['windspeed']
		day_city.data_real_time=hs[:time].to_time
		day_city.save
		puts '=================='+hs[:time]+'=Save OK!==============================='
	end
end
#start
main_get
