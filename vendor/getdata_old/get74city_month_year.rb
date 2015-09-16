require_relative './common.rb'
def main_get
	hs=Hash.new
	oneday=60*60*24
	time=Time.now.yesterday
	#京津冀月数据
	flag='temp_jjj_months'
	(0..5).each	do |t|
		hs=get_rank_json('sfcitiesrankbymonthoryear','CHINARANK','MONTH','')
		if hs != false
			break
		end
	end
	if hs==false
		puts 'Get temp_jjj_months error!'
	else
		if hs[:total]!='0' 
			save_db(hs,flag)	
		end
	end
	#京津冀年数据
	flag='temp_jjj_years'
	(0..5).each	do |t|
		hs=get_rank_json('sfcitiesrankbymonthoryear','CHINARANK','YEAR','')
		if hs != false
			break
		end
	end
	if hs==false
		puts 'Get temp_jjj_years error!'
	else
		if hs[:total]!='0'  
			save_db(hs,flag)	
		end
	end

	#74城市月数据

	flag='temp_sfcities_months'
	(0..5).each	do |t|
		hs=get_rank_json('sfcitiesrankbymonthoryear','CHINARANK','MONTH','')
		if hs != false
			break
		end
	end
	if hs==false
		puts 'Get temp_sfcities_months error!'
	else
		if hs[:total]!='0'
			save_db(hs,flag)	
		end
	end
	#74城市年数据
	flag='temp_sfcities_years'
	(0..5).each	do |t|
		hs=get_rank_json('sfcitiesrankbymonthoryear','CHINARANK','YEAR','')
		if hs != false
			break
		end
	end
	if hs==false
		puts 'Get temp_sfcities_years error!'
	else 
		temp=get_db_data(flag,'last','')
		if hs[:total]!='0'		
			save_db(hs,flag)	
		end
	end
end 

#保存数据到day_city
def save_db(hs,flag) 
	hs[:cities].each do |t|
		city_array = City.where("city_name like ?",t['city']+'_')
		if city_array.length==0
			city_array=City.where("city_name = ?",t['city'])
		end
		city=city_array[0]
		#判断京津冀
		temp_flag=true
		if flag=='temp_jjj_months'||flag=='temp_jjj_years'
			temp_city=TempJjjDay.first(13)
			temp_city.each do |t|
				if t.city_id==city.id
					temp_flag=true
				elsif t.city_id!=city.id
					temp_flag=false
				end
			end
		end
		if temp_flag==false
			next	
		end

		day_city=get_db_data(flag,'new','')	
		day_city.city_id=city.id
		day_city.SO2=t['so2']
		day_city.NO2=t['no2']
		day_city.CO=t['co_95']
		day_city.O3=t['o3_90']
		day_city.pm10=t['pm10']
		day_city.pm25=t['pm2_5']
		day_city.maxindex=t['maxindex']
		day_city.zonghezhishu=t['complexindex']
		day_city.main_pol=t['main_pollutant']
		day_city.data_real_time=Time.now
		day_city.save
		puts '=================='+Time.now.to_s+'=Save OK!==============================='
		day_city=get_db_data(flag,'last','')
		if flag!='temp_sfcities_months' && flag!='temp_sfcities_years' 
			change_rate=get_change_rate(flag,city.id,Time.now)
			if change_rate == false
				next
			end
			day_city.SO2_change_rate=change_rate[:SO2]
			day_city.NO2_change_rate=change_rate[:NO2]
			day_city.CO_change_rate=change_rate[:CO]
			day_city.O3_change_rate=change_rate[:O3]
			day_city.pm10_change_rate=change_rate[:pm10]
			day_city.pm25_change_rate=change_rate[:pm25]
			day_city.zongheindex_change_rate=change_rate[:zhzs]
		end
		day_city.save
	end
end
#start
main_get
