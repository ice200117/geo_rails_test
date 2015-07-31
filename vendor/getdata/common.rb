#数据库二次封装
def get_db_data(table_name,table_operation,table_operation_string)
	tabledata=Object.new
	case table_name
	when 'day_city'
		case table_operation
		when 'new'
			tabledata=DayCity.new
		when 'all'
			tabledata=DayCity.all	
		when 'last'
			tabledata=DayCity.last
		when 'where'
			tabledata=DayCity.where(table_operation_string)
		end
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
			response = HTTParty.get('http://www.izhenqi.cn/api/getdata_cityrank.php?secret='+secretstr+'&type='+typestr+'&key='+Digest::MD5.hexdigest(secretstr+typestr))
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

#计算综合指数 需要6项指标的数据
#先将当天的数据存储到数据库，再调用综合指数计算方法
#年平均二级标准SO2:60,NO2:40,PM10:70,PM2.5:35
#二级标准:CO 24小时平均4,O3日最大8小时平均160
#参数
#id=城市id
def get_zonghezhishu(flag)
	dayCity=get_db_data(flag,'last','')
	zonghezhishu_value=dayCity.SO2.to_f/60+dayCity.NO2.to_f/40+dayCity.pm10.to_f/70+dayCity.pm25.to_f/35+dayCity.CO.to_f/4+dayCity.O3.to_f/160
	zonghezhishu_value
end
#获得平均数
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
	while first_day<=this_day do
		temp_day=first_day+second_in_day
		sql_str=Array.new
		sql_str<<"data_real_time >=? AND data_real_time <=? AND city_id=?"
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
	if end_number==0
		return false
	end
	(0..end_number-1).each do |i|
		avg_so2 += so2_array [i]
		avg_no2 += no2_array[i]
		avg_pm10 += pm10_array[i].to_f
		avg_pm25 += pm25_array[i].to_f
		avg_co+=co_array[i].to_f
		avg_o3+=o3_array[i].to_f
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

	avg_co=co_array[co_index+1].to_f/4
	avg_o3=o3_array[o3_index+1].to_f/160

	hs=Hash.new
	hs['so2']=avg_so2
	hs['no2']=avg_no2
	hs['pm10']=avg_pm10
	hs['pm2_5']=avg_pm25
	hs['co']=avg_co
	hs['o3']=avg_o3

	hs
end

#计算同期对比
def get_change_rate(flag,id,time)
	sql_str=Hash.new
	sql_str[:data_real_time]=time.years_ago(1).beginning_of_day..time.years_ago(1).end_of_day
	sql_str[:city_id]=id

	last_years_data=get_db_data(flag,'where',sql_str)	
	if last_years_data.length == 0
		return false
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
