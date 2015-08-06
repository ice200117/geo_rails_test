require_relative './common.rb'
def main_get
	hs=Hash.new
	oneday=60*60*24

	#廊坊日数据
	stime=Time.now.years_ago(1).beginning_of_year
	etime=Time.now.yesterday.end_of_day
	while stime<etime
		(0..5).each	do |t|
			hs=get_rank_json('lf_history_data','','',stime)  
			if hs != false
				break
			end
		end
		flag='temp_lf_days'
		if hs==false
			puts 'Get temp_lf_days error!'	
		else
			if hs[:total]!='0'
				save_db(hs,flag)
			end
		end
		stime+=oneday
	end
	#廊坊月数据
	stime = Time.now.years_ago(1).beginning_of_year
	etime = Time.now.yesterday.end_of_day
	flag='temp_lf_months'
	while stime < etime 
		(0..5).each	do |t|
			hs=get_rank_json('lf_history_data','','',stime)
			if hs != false
				break
			end
		end
		flag='temp_lf_months'
		if hs==false 
			puts 'Get temp_lf_months error!'	
		else
			if hs[:total]!='0'
				save_db(hs,flag)	
			else
				while hs[:total]=='0'
					temp_one+=60*60*24	
					hs=get_rank_json('lf_history_data','','',stime-temp_one)
					hs[:time]=stime	
					save_db(hs,flag)
				end
			end
		end
		stime+=oneday
	end

	#廊坊年数据
	stime=Time.now.years_ago(1).beginning_of_year
	etime=Time.now.yesterday.end_of_day
	flag='temp_lf_years'
	while stime<etime
		(0..5).each	do |t|
			hs=get_rank_json('lf_history_data','','',stime)
			if hs != false
				break
			end
		end
		if hs==false
			puts 'Get temp_lf_years error!'
		else
			if hs[:total]!='0'
				save_db(hs,flag)	
			else
				while hs[:total]=='0'
					temp_one+=60*60*24	
					hs=get_rank_json('lf_history_data','','',stime-temp_one)
					hs[:time]=stime	
					save_db(hs,flag)
				end
			end
		end
		stime+=oneday
	end
	#京津冀日数据
	stime=Time.now.years_ago(1).beginning_of_year
	etime=Time.now.yesterday.end_of_day
	flag='temp_jjj_days'
	while stime<etime
		(0..5).each	do |t|
			hs=get_rank_json('china_history_data','JINGJINJIDATA','DAY',stime)
			if hs != false
				break
			end
		end
		if hs==false
			puts 'Get temp_jjj_days error!'
		else
			if hs[:total]!='0'
				save_db(hs,flag)
			end
		end
		stime+=oneday
	end	
	#京津冀月数据
	stime=Time.now.years_ago(1).beginning_of_year
	etime=Time.now.yesterday.end_of_day
	flag='temp_jjj_months'
	while stime<etime
		(0..5).each	do |t|
			hs=get_rank_json('china_history_data','JINGJINJIDATA','DAY',stime)
			if hs != false
				break
			end
		end
		if hs==false
			puts 'Get temp_jjj_months error!'
		else
			if hs[:total]!='0'
				save_db(hs,flag)	
			else
				while hs[:total]=='0'
					temp_one=60*60*24
					hs=get_rank_json('china_history_data','JINGJINJIDATA','DAY',stime+temp_one)
					hs[:time]=stime	
					save_db(hs,flag)	
				end
			end
		end
		stime+=oneday
	end
	#京津冀年数据
	stime=Time.now.years_ago(1).beginning_of_year
	etime=Time.now.yesterday.end_of_day
	flag='temp_jjj_years'
	while stime<etime
		(0..5).each	do |t|
			hs=get_rank_json('china_history_data','JINGJINJIDATA','DAY',stime)
			if hs != false
				break
			end
		end
		if hs==false
			puts 'Get temp_jjj_years error!'
		else
			if hs[:total]!='0'
				save_db(hs,flag)	
			else
				while hs[:total]=='0'
					temp_one=60*60*24
					hs=get_rank_json('china_history_data','JINGJINJIDATA','DAY',stime+temp_one)
					hs[:time]=stime	
					save_db(hs,flag)	
				end
			end
		end
		stime+=oneday
	end

	#74城市日数据
	stime=Time.now.beginning_of_year
	etime=Time.now.yesterday.end_of_day
	flag='temp_sfcities_days'
	while stime<etime
		(0..5).each	do |t|
			hs=get_rank_json('china_history_data','CHINADATA','DAY',stime)
			if hs != false
				break
			end
		end
		if hs==false
			puts 'Get temp_sfcities_days error!'
		else
			if hs[:total]!='0'
				save_db(hs,flag)
			end
		end
		stime+=oneday
	end
	#74城市月数据
	stime=Time.now.beginning_of_year
	etime=Time.now.yesterday.end_of_day
	flag='temp_sfcities_months'
	while stime<etime
		(0..5).each	do |t|
			hs=get_rank_json('china_history_data','CHINADATA','DAY',stime)
			if hs != false
				break
			end
		end
		if hs==false
			puts 'Get temp_sfcities_months error!'
		else
			if hs[:total]!='0'
				save_db(hs,flag)	
			else
				while hs[:total]=='0'
					temp_one=60*60*24
					hs=get_rank_json('china_history_data','CHINADATA','DAY',stime-temp_one)
					hs[:time]=stime	
					save_db(hs,flag)	
				end
			end
		end
		stime+=oneday
	end

	#74城市年数据
	stime=Time.now.beginning_of_year
	etime=Time.now.yesterday.end_of_day
	flag='temp_sfcities_years'
	while stime<=etime
		(0..5).each	do |t|
			hs=get_rank_json('china_history_data','CHINADATA','DAY',stime)
			if hs != false
				break
			end
		end
		if hs==false
			puts 'Get temp_sfcities_years error!'
		else 
			if hs[:total]!='0'
				save_db(hs,flag)	
			else
				while hs[:total]=='0'
					temp_one=60*60*24
					hs=get_rank_json('china_history_data','CHINADATA','DAY',stime-temp_one)
					hs[:time]=stime	
					save_db(hs,flag)	
				end
			end
		end
		stime+=oneday
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
		case flag
		when 'temp_lf_months','temp_lf_years','temp_jjj_months','temp_jjj_years','temp_sfcities_months','temp_sfcities_years'
			t=Hash.new
			t=get_avg_data(flag,city.id,hs[:time])
			if t==false
				next
			end
		end
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
		puts '==========='+flag+'='+hs[:time]+'=Save OK!=========='
		day_city=get_db_data(flag,'last','')
		if hs[:time].to_time.year.to_i>2014.to_i&&flag!='temp_sfcities_days'&&flag!='temp_sfcities_months'&&flag!='temp_sfcities_years' 
			change_rate=get_change_rate(flag,city.id,day_city.data_real_time)
			if change_rate==false
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
