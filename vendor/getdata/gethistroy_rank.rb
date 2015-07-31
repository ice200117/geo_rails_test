require './common.rb'
def main_get
	hs=Hash.new
	oneday=60*60*24

#	#廊坊日数据
#	stime=Time.now.years_ago(1).beginning_of_year
#	etime=Time.now.yesterday.end_of_day
#	while stime<etime
#		(0..5).each	do |t|
#			hs=get_rank_json('lf_history_data','','',stime)  
#			if hs != false
#				break
#			end
#		end
#		flag='temp_lf_days'
#		if hs==false
#			puts 'Get temp_lf_days error!'	
#		else
#			if hs[:total]!='0'
#				save_db(hs,flag)
#			end
#		end
#		stime+=oneday
#	end
#	#廊坊月数据
#	stime = Time.now.years_ago(1).beginning_of_year
#	etime = Time.now.yesterday.end_of_day
#	flag='temp_lf_months'
#	while stime < etime 
#		(0..5).each	do |t|
#			hs=get_rank_json('lf_history_data','','',stime)
#			if hs != false
#				break
#			end
#		end
#		flag='temp_lf_months'
#		if hs==false 
#			puts 'Get temp_lf_months error!'	
#		else
#			if hs[:total]!='0'
#				save_db(hs,flag)	
#			else
#				while hs[:total]=='0'
#					temp_one+=60*60*24	
#					hs=get_rank_json('lf_history_data','','',stime-temp_one)
#					hs[:time]=stime	
#					save_db(hs,flag)
#				end
#			end
#		end
#		stime+=oneday
#	end
#
#	#廊坊年数据
#	stime=Time.now.years_ago(1).beginning_of_year
#	etime=Time.now.yesterday.end_of_day
#	flag='temp_lf_years'
#	while stime<etime
#		(0..5).each	do |t|
#			hs=get_rank_json('lf_history_data','','',stime)
#			if hs != false
#				break
#			end
#		end
#		if hs==false
#			puts 'Get temp_lf_years error!'
#		else
#			if hs[:total]!='0'
#				save_db(hs,flag)	
#			else
#				while hs[:total]=='0'
#					temp_one+=60*60*24	
#					hs=get_rank_json('lf_history_data','','',stime-temp_one)
#					hs[:time]=stime	
#					save_db(hs,flag)
#				end
#			end
#		end
#		stime+=oneday
#	end
	#京津冀日数据
	stime=Time.now.years_ago(1).beginning_of_year
#	stime=Time.now.beginning_of_year
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

#	#74城市日数据
#	stime=Time.now.beginning_of_year
#	etime=Time.now.yesterday.end_of_day
#	flag='temp_sfcities_days'
#	while stime<etime
#		(0..5).each	do |t|
#			hs=get_rank_json('china_history_data','CHINADATA','DAY',stime)
#			if hs != false
#				break
#			end
#		end
#		if hs==false
#			puts 'Get temp_sfcities_days error!'
#		else
#			if hs[:total]!='0'
#				save_db(hs,flag)
#			end
#		end
#		stime+=oneday
#	end
#	#74城市月数据
#	stime=Time.now.beginning_of_year
#	etime=Time.now.yesterday.end_of_day
#	flag='temp_sfcities_months'
#	while stime<etime
#		(0..5).each	do |t|
#			hs=get_rank_json('china_history_data','CHINADATA','DAY',stime)
#			if hs != false
#				break
#			end
#		end
#		if hs==false
#			puts 'Get temp_sfcities_months error!'
#		else
#			if hs[:total]!='0'
#				save_db(hs,flag)	
#			else
#				while hs[:total]=='0'
#					temp_one=60*60*24
#					hs=get_rank_json('china_history_data','CHINADATA','DAY',stime-temp_one)
#					hs[:time]=stime	
#					save_db(hs,flag)	
#				end
#			end
#		end
#		stime+=oneday
#	end
#
#	#74城市年数据
#	stime=Time.now.beginning_of_year
#	etime=Time.now.yesterday.end_of_day
#	flag='temp_sfcities_years'
#	while stime<=etime
#		(0..5).each	do |t|
#			hs=get_rank_json('china_history_data','CHINADATA','DAY',stime)
#			if hs != false
#				break
#			end
#		end
#		if hs==false
#			puts 'Get temp_sfcities_years error!'
#		else 
#			if hs[:total]!='0'
#				save_db(hs,flag)	
#			else
#				while hs[:total]=='0'
#					temp_one=60*60*24
#					hs=get_rank_json('china_history_data','CHINADATA','DAY',stime-temp_one)
#					hs[:time]=stime	
#					save_db(hs,flag)	
#				end
#			end
#		end
#		stime+=oneday
#	end
end 

#保存数据到day_city
def save_db(hs,flag) 
	hs[:cities].each do |t|
		city_array = City.where("city_name like ?",t['city']+'_')
		if city_array.length==0
			city_array=City.where("city_name = ?",t['city'])
		end
		city=city_array[0]
		day_city=get_db_data(flag,'new','')	
		day_city.city_id=city.id
		case flag
		when 'temp_lf_months','temp_lf_years','temp_jjj_months','temp_jjj_years','temp_sfcities_months','temp_sfcities_years'
			t=Hash.new
			t=get_avg_data(flag,city.id,hs[:time])
		end
		day_city.SO2=t['so2']
		day_city.NO2=t['no2']
		day_city.CO=t['co']
		day_city.O3=t['o3']
		puts t['o3']
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
		puts day_city.O3 
		day_city.zonghezhishu=get_zonghezhishu(flag)
		day_city.save
		puts '=================='+hs[:time]+'=Save OK!==============================='
		day_city=get_db_data(flag,'last','')
		if hs[:time].to_time.year.to_i>2014.to_i&&flag!='temp_sfcities_days'&&flag!='temp_sfcities_months'&&flag!='temp_sfcities_years' 
			puts day_city.data_real_time
			change_rate=get_change_rate(flag,city.id,day_city.data_real_time)
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
def get_avg_data(flag,id,time)
	second_in_day=60*60*24
	#指标数组，暂存数据进行处理
	so2_array=Array.new
	no2_array=Array.new
	pm10_array=Array.new
	pm25_array=Array.new
	co_array=Array.new
	o3_array=Array.new



	#遍历当月从1号到当天，获取数据
	first_day=time.to_time.beginning_of_month
	this_day=time.to_time.end_of_day
	if flag=='temp_lf_years'||flag=='temp_jjj_years'||flag=='temp_sfcities_years'
		first_day=time.to_time.beginning_of_year
	end
	case flag
	when 'temp_lf_months','temp_lf_years'
		flag='temp_lf_days'
	when 'temp_jjj_months','temp_jjj_years'
		flag='temp_jjj_days'
	when 'temp_sfcities_months','temp_sfcities_years'
		flag='temp_sfcities_days'
	end
	while first_day<this_day do
		temp_day=first_day+second_in_day
		sql_str=Array.new
		sql_str<<"data_real_time >=? AND data_real_time <=? AND city_id = ?"
		sql_str<<first_day
		sql_str<<temp_day
		sql_str<<id
		daycity=get_db_data(flag,'where',sql_str)	
		if daycity.length>0
			day_city=daycity[0]
			if !day_city.SO2.nil?
				so2_array<<day_city.SO2
			end
			if !day_city.NO2.nil?
				no2_array<<day_city.NO2
			end
			if !day_city.pm10.nil?
				pm10_array<<day_city.pm10
			end
			if !day_city.pm25.nil?
				pm25_array<<day_city.pm25
			end
			if !day_city.CO.nil?
				co_array<<day_city.CO
			end
			if !day_city.O3.nil?
				o3_array<<day_city.O3
			end
		end
		first_day=temp_day
	end
	avg_so2=0.to_f
	avg_no2=0.to_f
	avg_pm10=0.to_f
	avg_pm25=0.to_f
	avg_co=0.to_f
	avg_o3=0.to_f
	end_number=so2_array.length
	(0..end_number-1).each do |i|
		avg_so2 += so2_array [i].to_f
		avg_no2 += no2_array[i].to_f
		avg_pm10 += pm10_array[i].to_f
		avg_pm25 += pm25_array[i].to_f
		avg_co += co_array[i].to_f
		avg_o3 += o3_array[i].to_f
	end
	#计算月均值
	avg_so2/=end_number
	avg_no2/=end_number
	avg_pm10/=end_number
	avg_pm25/=end_number
	avg_co/=end_number
	avg_o3/=end_number

	#co o3百分位数计算
	co_array = co_array.sort_by{|x| x.to_f}
	o3_array = o3_array.sort_by{|x| x.to_f}

	co_index=(co_array.length()*0.95).floor
	o3_index=(o3_array.length()*0.9).floor

	avg_co=co_array[co_index].to_f
	avg_o3=o3_array[o3_index].to_f

	hs=Hash.new
	hs['so2']=avg_so2
	hs['no2']=avg_no2
	hs['pm10']=avg_pm10
	hs['pm2_5']=avg_pm25
	hs['co']=avg_co
	hs['o3']=avg_o3
	hs
end

#计算综合指数 需要6项指标的数据
#先将当天的数据存储到数据库，再调用综合指数计算方法
#年平均二级标准SO2:60,NO2:40,PM10:70,PM2.5:35
#二级标准:CO 24小时平均4,O3日最大8小时平均160
def get_zonghezhishu(flag)
	dayCity=get_db_data(flag,'last','')
	zonghezhishu_value=dayCity.SO2.to_f/60+dayCity.NO2.to_f/40+dayCity.pm10.to_f/70+dayCity.pm25.to_f/35+dayCity.CO.to_f/4+dayCity.O3.to_f/160
	zonghezhishu_value
end
#计算同期对比
def get_change_rate(flag,id,time)
	stime=time.beginning_of_day
	etime=time.end_of_day
	sql_str=Hash.new
	sql_str[:data_real_time]=stime.years_ago(1)..etime.years_ago(1)
	sql_str[:city_id]=id
	puts id
	last_years_data=get_db_data(flag,'where',sql_str)
	puts last_years_data[0]
	#如何同期没有数据，循环加一天，查找数据	
	hs=Hash.new
	while last_years_data.length==0
		stime+=60*60*24
		etime+=60*60*24
		sql_str=Hash.new
		sql_str[:data_real_time]=stime.years_ago(1)..etime.years_ago(1)
		sql_str[:city_id]=id
		last_years_data=get_db_data(flag,'where',sql_str)
		if stime.years_ago(1)>Time.now.beginning_of_year
			hs[:SO2]=0
			hs[:NO2]=0
			hs[:pm10]=0
			hs[:pm25]=0
			hs[:CO]=0
			hs[:O3]=0
			hs[:zhs]=0
			hs
			return
		end
		puts 'get_change_rate error'
	end
	last_years=last_years_data[0]

	now_years=get_db_data(flag,'last','')

	hs=Hash.new
	if !now_years.SO2.nil? && !last_years.SO2.nil?
		hs[:SO2]=(now_years.SO2-last_years.SO2)/last_years.SO2
	end
	if !now_years.NO2.nil? && !last_years.NO2.nil?
		hs[:NO2]=(now_years.NO2-last_years.NO2)/last_years.NO2
	end
	if !now_years.pm10.nil? && !last_years.pm10.nil?
		hs[:pm10]=(now_years.pm10-last_years.pm10)/last_years.pm10
	end
	if !now_years.pm25.nil? && !last_years.pm25.nil?
		hs[:pm25]=(now_years.pm25-last_years.pm25)/last_years.pm25
	end
	if !now_years.CO.nil? && !last_years.CO.nil?
		hs[:CO]=(now_years.CO-last_years.CO)/last_years.CO
	end
	if !now_years.O3.nil? && !last_years.O3.nil?
		hs[:O3]=(now_years.O3-last_years.O3)/last_years.O3
	end
	if !now_years.zonghezhishu.nil? && !last_years.zonghezhishu.nil?
		hs[:zhzs]=(now_years.zonghezhishu-last_years.zonghezhishu)/last_years.zonghezhishu
	end
	hs
end
#start
main_get
