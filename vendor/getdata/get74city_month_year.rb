#数据库二次封装
def get_db_data(table_name,table_operation,table_operation_string)
	tabledata=Object.new
	case table_name
	when 'temp_lf_hours'
		case table_operation
		when 'new'
			tabledata=TempLfHour.new	
		when 'all'
			tabledata=TempLfHour.all
		when 'last'
			tabledata=TempLfHour.last
		when 'where'
			tabledata=TempLfHour.where(table_operation_string)	
		end
	when 'temp_lf_days'
		case table_operation
		when 'new'
			tabledata=TempLfDay.new
		when 'all'
			tabledata=TempLfDay.all
		when 'last'
			tabledata=TempLfDay.last
		when 'where'
			tabledata=TempLfDay.where(table_operation_string)
		end
	when 'temp_lf_months'
		case table_operation
		when 'new'
			tabledata=TempLfMonth.new
		when 'all' 
			tabledata=TempLfMonth.all
		when 'last'
			tabledata=TempLfMonth.last
		when 'where'
			tabledata=TempLfMonth.where(table_operation_string)
		end
	when 'temp_lf_years'
		case table_operation
		when 'new'
			tabledata=TempLfYear.new
		when 'all'
			tabledata=TempLfYear.all
		when 'last'
			tabledata=TempLfYear.last
		when 'where'
			tabledata=TempLfYear.where(table_operation_string)
		end
	when 'temp_jjj_days'
		case table_operation
		when 'new'
			tabledata=TempJjjDay.new
		when 'all'
			tabledata=TempJjjDay.all
		when 'last'			
			tabledata=TempJjjDay.last
		when 'where'
			tabledata=TempJjjDay.where(table_operation_string)
		end

	when 'temp_jjj_months'
		case table_operation
		when 'new'
			tabledata=TempJjjMonth.new
		when 'all' 
			tabledata=TempJjjMonth.all
		when 'last'
			tabledata=TempJjjMonth.last
		when 'where'
			tabledata=TempJjjMonth.where(table_operation_string)
		end																						
	when 'temp_jjj_years'
		case table_operation
		when 'new' 
			tabledata=TempJjjYear.new
		when 'all'
			tabledata=TempJjjYear.all
		when 'last'
			tabledata=TempJjjYear.last	
		when 'where'
			tabledata=TempJjjYear.where(table_operation_string)
		end
	when 'temp_sfcities_days'
		case table_operation
		when 'new' 
			tabledata=TempSfcitiesDay.new	
		when 'all'
			tabledata=TempSfcitiesDay.all
		when 'last'
			tabledata=TempSfcitiesDay.last
		when 'where'			
			tabledata=TempSfcitiesDay.where(table_operation_string)	
		end

	when 'temp_sfcities_months'
		case table_operation
		when 'new'
			tabledata=TempSfcitiesMonth.new
		when 'all'
			tabledata=TempSfcitiesMonth.all
		when 'last'
			tabledata=TempSfcitiesMonth.last
		when 'where'
			tabledata=TempSfcitiesMonth.where(table_operation_string)
		end
	when 'temp_sfcities_years'
		case table_operation
		when 'new'
			tabledata=TempSfcitiesYear.new	
		when 'all' 
			tabledata=TempSfcitiesYear.all
		when 'last'
			tabledata=TempSfcitiesYear.last	
		when 'where'
			tabledata=TempSfcitiesYear.where(table_operation_string)
		end
	end
	tabledata	
end


#参数
#web_flag:接口区别标志
#secretstr:城市选择， 
#typestr:数据类型  
#datestr：日期  格式(YYYY-MM-DD)
def get_rank_json(web_flag,secretstr,typestr,datestr)
	if datestr!=''
		datestr=datestr.strftime("%Y-%m-%d")
	end
	hs = Hash.new
	begin
		if web_flag == 'shishi_china_rank_data'
			#真气网74城市实时/日排名
			#secretstr:CHINARANK
			#type:HOUR(实时)，DAY(日)
			response = HTTParty.get('http://www.izhenqi.cn/api/getdata_cityrank.php?secret='+secretstr+'&type='+typestr+'&key='+digest::md5.hexdigest(secretstr+typestr))
		elsif web_flag == 'china_history_data' 
			#74城市和京津冀历史日接口
			option = {secret:secretstr,type:typestr,date:datestr,key:Digest::MD5.hexdigest(secretstr+typestr+datestr)}
			response = HTTParty.post('http://www.izhenqi.cn/api/getdata_history.php', :body => option)
		elsif web_flag == 'shishi_rank_data' 
			#74城市 京津冀 廊坊实时数据
			option = {secret:secretstr,type:typestr,key:Digest::MD5.hexdigest(secretstr+typestr) }
			response = HTTParty.post('http://www.izhenqi.cn/api/getrank.php', :body => option)
		elsif web_flag == 'china_rank_data_of_month'
			#74城市月排名数据
			option = {secret:secretstr,type:typestr,date:datestr,key:Digest::MD5.hexdigest(secretstr+typestr+datestr) }
			response = HTTParty.post('http://www.izhenqi.cn/api/getrank_month.php', :body => option)
		elsif web_flag == 'sfcitiesrankbymonthoryear'
			#74 城市当月和当年综合指数排名
			option = {secret:secretstr,type:typestr,key:Digest::MD5.hexdigest(secretstr+typestr) }
			response = HTTParty.post('http://www.izhenqi.cn/api/getrank_forecast.php', :body => option)
		elsif web_flag == 'lf_history_data'
			#廊坊区县历史数据排名
			response  = HTTParty.get('http://115.28.227.231:8082/api/data/day-qxday?date='+datestr)
		end
		json_data=JSON.parse(response.body)
		if web_flag == 'lf_history_data'
			hs[:time] = json_data['date']
			hs[:cities]=lf_hdistory_data_column_name_modify(json_data['rows'])
		else 
			hs[:time] =json_data['time']
			hs[:cities] = json_data['rows']
		end
		hs[:total]=json_data['total']
	rescue
		hs=false
	end 
	hs
end
def lf_history_data_column_name_modify(hs)
	data_array=Array.new
	hs.each do |t|
		temp_day=Hash.new
		temp_day['city']=t["city_name"]
		temp_day['so2']=t["so2nd"]		
		temp_day['no2']=t["no2nd"]
		temp_day['co']=t["cond"]
		temp_day['o3']=t["o3_8hnd"]
		temp_day['pm10']=t["pm10nd"]
		temp_day['pm2_5']=t["pm25nd"]
		temp_day['aqi']=t["aqi"]
		if t['quality'].nil?
			temp_day['quality']=t["quality"]
		end
		temp_day['main_pollutant']=t["main_pollutant"]
		data_array<<temp_day
	end
	data_array

end
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
#计算同期对比
def get_change_rate(flag,id,time)
	stime=time.to_time.beginning_of_day
	etime=time.to_time.end_of_day
	sql_str=Hash.new
	sql_str[:data_real_time]=stime.years_ago(1)..etime.years_ago(1)
	sql_str[:city_id]=id
	last_years_data=get_db_data(flag,'where',sql_str)

	#如何同期没有数据，循环加一天，查找数据	
	hs=Hash.new
	while last_years_data.length==0
		stime+=60*60*24
		etime+=60*60*24
		sql_str=Hash.new
		sql_str[:created_at]=stime.years_ago(1)..etime.years_ago(1)
		sql_str[:city_id]=id
		last_years_data=get_db_data(flag,'where',sql_str)
		if stime.years_ago(1)>=Time.now.beginning_of_year
			hs[:SO2]=''
			hs[:NO2]=''
			hs[:pm10]=''
			hs[:pm25]=''
			hs[:CO]=''
			hs[:O3]=''
			hs[:zhs]=''
			hs
			return
		end
		puts 'get_change_rate while'
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
