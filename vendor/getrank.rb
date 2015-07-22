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
			tabledata=TempLfHours.new	
		when 'all'
			tabledata=TempLfHours.all
		when 'last'
			tabledata=TempLfHours.last
		when 'where'
			tabledata=TempLfHours.where(table_operation_string)	
		end
	when 'temp_lf_days'
		case table_operation
		when 'new'
			tabledata=TempLfDays.new
		when 'all'
			tabledata=TempLfDays.all
		when 'last'
			tabledata=TempLfDays.last
		when 'where'
			tabledata=TempLfDays.where(table_operation_string)
		end
	when 'temp_lf_months'
		case table_operation
		when 'new'
			tabledata=TempLfMonths.new
		when 'all' 
			tabledata=TempLfMonths.all
		when 'last'
			tabledata=TempLfMonths.last
		when 'where'
			tabledata=TempLfMonths.where(table_operation_string)
		end
	when 'temp_lf_years'
		case table_operation
		when 'new'
			tabledata=TempLfYears.new
		when 'all'
			tabledata=TempLfYears.all
		when 'last'
			tabledata=TempLfYears.last
		when 'where'
			tabledata=TempLfYears.where(table_operation_string)
		end
	when 'temp_jjj_days'
		case table_operation
		when 'new'
			tabledata=TempJjjDays.new
		when 'all'
			tabledata=TempJjjDays.all
		when 'last'			
			tabledata=TempJjjDays.last
		when 'where'
			tabledata=TempJjjDays.where(table_operation_string)
		end

	when 'temp_jjj_months'
		case table_operation
		when 'new'
			tabledata=TempJjjMonths.new
		when 'all' 
			tabledata=TempJjjMonths.all
		when 'last'
			tabledata=TempJjjMonths.last
		when 'where'
			tabledata=TempJjjMonths.where(table_operation_string)
		end																						
	when 'temp_jjj_years'
		case table_operation
		when 'new' 
			tabledata=TempJjjYears.new
		when 'all'
			tabledata=TempJjjYears.all
		when 'last'
			tabledata=TempJjjYears.last	
		when 'where'
			tabledata=TempJjjYears.where(table_operation_string)
		end
	when 'temp_sfcities_days'
		case table_operation
		when 'new' 
			tabledata=TempSfcitiesDays.new	
		when 'all'
			tabledata=TempSfcitiesDays.all
		when 'last'
			tabledata=TempSfcitiesDays.last
		when 'where'			
			tabledata=TempSfcitiesDays.where(table_operation_string)	
		end

	when 'temp_sfcities_months'
		case table_operation
		when 'new'
			tabledata=TempSfcitiesMonths.new
		when 'all'
			tabledata=TempSfcitiesMonths.all
		when 'last'
			tabledata=TempSfcitiesMonths.last
		when 'where'
			tabledata=TempSfcitiesMonths.where(table_operation_string)
		end
	when 'temp_sfcities_years'
		case table_operation
		when 'new'
			tabledata=TempSfcitiesYears.new	
		when 'all' 
			tabledata=TempSfcitiesYears.all
		when 'last'
			tabledata=TempSfcitiesYears.last	
		when 'where'
			tabledata=TempSfcitiesYears.where(table_operation_string)
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
	datestr=datestr.strftime("%Y-%m-%d")
	hs = Hash.new
	begin
		if web_flag == 'shishi_china_rank_data'
			#真气网74城市实时/日排名
			#secretstr:CHINARANK
			#type:HOUR(实时)，DAY(日)
			response = httparty.get('http://www.izhenqi.cn/api/getdata_cityrank.php?secret='+secretstr+'&type='+typestr+'&key='+digest::md5.hexdigest(secretstr+typestr))
		elsif web_flag == 'china_history_data' 
			#74城市和京津冀历史日接口
			option = {secret:secretstr,type:typestr,date:datestr,key:digest::md5.hexdigest(secretstr+typestr+datestr)}
			response = httparty.post('http://www.izhenqi.cn/api/getdata_history.php', :body => option)
		elsif web_flag == 'shishi_rank_data' 
			#74城市 京津冀 廊坊实时数据
			option = {secret:secretstr,type:typestr,key:digest::md5.hexdigest(secretstr+typestr) }
			response = httparty.post('http://www.izhenqi.cn/api/getrank.php', :body => option)
		elsif web_flag == 'china_rank_data_of_month'
			#74城市月排名数据
			option = {secret:secretstr,type:typestr,date:datestr,key:digest::md5.hexdigest(secretstr+typestr+datestr) }
			response = httparty.post('http://www.izhenqi.cn/api/getrank_month.php', :body => option)
		elsif web_flag == 'sfcitiesrankbymonthoryear'
			#74 城市当月 和当年综合指数排名
			option = {secret:secretstr,type:typestr,key:Digest::MD5.hexdigest(secretstr+typestr) }
			response = HTTParty.post('http://www.izhenqi.cn/api/getrank_forecast.php', :body => option)
		elsif web_flag == 'lf_history_data'
			#廊坊区县历史数据排名
			response  = HTTParty.get('http://115.28.227.231:8082/api/data/day-qxday?date='+datestr)
		end
		json_data=JSON.parse(response.body)
		if webUrl == 'lf_history_data'
			hs[:time] = json_data['date']
			hs=lf_history_data_column_name_modify(hs)
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
	temp_city=Hash.new
	hs[:cities].each do |t|
		temp_day['city_name']=t['city_name']
		temp_day['SO2']=t['so2nd']		
		temp_day['NO2']=t['no2nd']
		temp_day['CO']=t['cond']
		temp_day['O3']=t['o3_8nd']
		temp_day['pm10']=t['pm10nd']
		temp_day['pm2_5']=t['pm25nd']
		temp_day['aqi']=t['aqi']
		temp_day['main_pollutant']=t['main_pollutant']
	end
	hs[:cities]=temp_day
	hs
end
def main_get
	hs=Hash.new
	oneday=60*60*24
	#廊坊日数据
	hs=get_rank_json('lf_history_data','','',Time.now.yesterday)  
	flag='temp_lf_days'
	if hs===false
		puts 'Get temp_lf_days error!'	
	else
		if hs[:total]!='0'
			save_db(hs,flag)
		end
	end

	#廊坊月数据
	stime = Time.now.beginning_of_month
	etime = Time.now.yesterday
	flag='temp_lf_months'
	while stime >= etime 
		hs=get_rank_json('lf_history_data','','',stime)
		stime+=oneday
		if hs===false 
			puts 'Get temp_lf_months error!'	
		else
			save_db(hs,flag)	
		end
	end

	#廊坊年数据
	stime=Time.now.beginning_of_year
	etime=Time.now.yesterday
	flag='temp_lf_years'
	while stime>=etime
		hs=get_rank_json('lf_history_data','','',stime)
		stime+=oneday
		if hs===false
			puts 'Get temp_lf_years error!'
		else
			save_db(hs,flag)
		end
	end

	#京津冀日数据
	stime
end 

#保存数据到day_city
def save_db(hs,flag) 
	hs[:cities].each do |t|
		city = City.find_by(city_name:t[:city])
		day_city=get_db_data(flag,'new','')	
		day_city.city_id=city.id
		day_city.SO2=t['SO2']
		day_city.NO2=t['NO2']
		day_city.CO=t['CO']
		day_city.O3=t['O3']
		day_city.pm10=t['pm10']
		day_city.pm25=t['pm2_5']
		day_city.AQI=t['aqi']
		if !t['quality'].nil?
			day_city.level=t['quality']
		end
		day_city.main_pol=t['main_pollutant']
		day_city.created_at=t['time'].to_date
		day_city.save
		if flag!='temp_lf_hours'
			day_city=get_db_data(flag,'last','')
			day_city.zonghezhishu=get_zonghezhishu(flag,city.id)
			if t['time'].to_date.year.to_i > 2014.to_i 
				change_rate=get_change_rate(flag,city.id)
				day_city.SO2_change_rate=change_rate[:SO2]
				day_city.NO2_change_rate=change_rate[:NO2]
				day_city.CO_change_rate=change_rate[:CO]
				day_city.O3_change_rate=change_rate[:O3]
				day_city.pm10_change_rate=change_rate[:pm10]
				day_city.pm25_change_rate=change_rate[:pm25]
				day_city.zongheindex_change_rate=change_rate[:zonghezhishu]
			end
			day_city.save
		end
	end
end
def get_zonghezhishu(flag,id)
	#计算综合指数 需要6项指标的数据
	#先将当天的数据存储到数据库，再调用综合指数计算方法
	#年平均二级标准SO2:60,NO2:40,PM10:70,PM2.5:35
	#二级标准:CO 24小时平均4,O3日最大8小时平均160
	#参数
	#id=城市id
	time=Time.now()
	zonghezhishu_value
	second_in_day=60*60*24
	case flag 
	when 'temp_lf_days','temp_jjj_days','temp_sfcities_days' 
		start_date=time.yesterday.beginning_of_day()
		end_date=time.yesterday.end_of_day()
		dayCity=get_db_data(flag,'last','')
		zonghezhishu_value=dayCity.SO2.to_f/60+dayCity.NO2.to_f/40+dayCity.pm10.to_f/70+dayCity.pm25.to_f/35+dayCity.CO.to_f/4+dayCity.O3.to_f/160
	when 'temp_lf_months','temp_jjj_months','temp_sfcities_months'
		dayCity=get_db_data(flag,'new','')

	#指标数组，暂存数据进行处理
	so2_array=Array.new
	no2_array=Array.new
	pm10_array=Array.new
	pm25_array=Array.new
	co_array=Array.new
	o3_array=Array.new

		#遍历当月从1号到当天，获取数据
		first_day=time.beginning_of_month()
		this_day=time.yesterday().end_of_day()
		while first_day<=this_day do
			temp_day=first_day+second_in_day
			sql_str='["created_at >= ? AND created_at <= ?",'+first_day.to_date+','+temp_day.to_date+']'
			dayCity=get_db_data(flag,'where',sql_str)	
			first_day=temp_day
			if dayCity.nil?
				next
			else
				so2_array  << day_city.SO2.to_f
				no2_array << day_city.NO2.to_f
				pm10_array << day_city.pm10.to_f
				pm25_array << day_city.pm25.to_f
				co_array << day_city.CO.to_f
				o3_array << day_city.O3.to_f
			end
		end
		avg_so2=0
		avg_no2=0
		avg_pm10=0
		avg_pm25=0
		end_number=so2_array.length-1
		(0..end_number).each do |i|
			avg_so2 += so2_array [i]
			avg_no2 += no2_array[i]
			avg_pm10 += pm10_array[i]
			avg_pm25 += pm25_array[i]
		end
		#计算月均值
		avg_so2/=end_number
		avg_no2/=end_number
		avg_pm10/=end_number
		avg_pm25/=end_number

	#co o3百分位数计算
	co_array = co_array.sort_by{|x| x.to_f}
	o3_array = o3_array.sort_by{|x| x.to_f}

	co_index=(co_array.length()*0.95).floor
	o3_index=(o3_array.length()*0.9).floor

		zonghezhishu_value=avg_so2.to_f/60+avg_no2.to_f/40+avg_pm10.to_f/70+avg_pm25.to_f/35+co_array[co_index+1].to_f/4+o3_array[o3_index+1].to_f/160
	when 'temp_lf_years','temp_jjj_years','temp_sfcities_years'
		#计算综合指数 需要6项指标的数据,so2,no2,pm10,pm25年均值，co年总天数第95百分位，o3年总天数第90百分位
		dayCity=get_db_data(flag,'new','')
		#指标数组，暂存数据进行处理
		so2_array=Array.new
		no2_array=Array.new
		pm10_array=Array.new
		pm25_array=Array.new
		co_array=Array.new
		o3_array=Array.new

		#遍历当月从1号到当天，获取数据
		second_in_day=60*60*24
		first_day=time.beginning_of_year()
		this_day=time.end_of_day()
		while first_day<=this_day do
			temp_day=first_day+second_in_day
			sql_str='["created_at >= ? AND created_at <= ?",'+first_day.to_date+','+temp_day.to_date+']'
			dayCity=get_db_data(flag,'where',sql_str)
			first_day=temp_day
			if dayCity.nil?
				next
			else
				so2_array << day_city.SO2.to_f
				no2_array << day_city.NO2.to_f
				pm10_array << day_city.pm10.to_f
				pm25_array << day_city.pm25.to_f
				co_array << day_city.CO.to_f
				o3_array << day_city.O3.to_f
			end
		end
		avg_so2=0
		avg_no2=0
		avg_pm10=0
		avg_pm25=0
		end_number=so2_array.length-1
		(0..end_number).each do |i|
			avg_so2 += so2_array[i]
			avg_no2 += no2_array[i]
			avg_pm10 += pm10_array[i]
			avg_pm25 += pm25_array[i]
		end
		#计算年均值
		avg_so2/=end_number
		avg_no2/=end_number
		avg_pm10/=end_number
		avg_pm25/=end_number

		#co o3百分位数计算
		co_array = co_array.sort_by{|x| x.to_f}
		o3_array = o3_array.sort_by{|x| x.to_f}

		co_index=(co_array.length()*0.95).floor
		o3_index=(o3_array.length()*0.9).floor

		zonghezhishu_value=avg_so2.to_f/60+avg_no2.to_f/40+avg_pm10.to_f/70+avg_pm25.to_f/35+co_array[co_index+1].to_f/4+o3_array[o3_index+1].to_f/160
	end
	zonghezhishu_value
end
def get_day_zonghezhishu(id)
	#计算综合指数 需要6项指标的数据
	#先将当天的数据存储到数据库，再调用综合指数计算方法
	#年平均二级标准SO2:60,NO2:40,PM10:70,PM2.5:35
	#二级标准:CO 24小时平均4,O3日最大8小时平均160
	#参数
	#id=城市id
	time=Time.now()
	start_date=time.yesterday.beginning_of_day()
	end_date=time.yesterday.end_of_day()
	dayCity=DayCity.last
	zonghezhishu_value=dayCity.SO2.to_f/60+dayCity.NO2.to_f/40+dayCity.pm10.to_f/70+dayCity.pm25.to_f/35+dayCity.CO.to_f/4+dayCity.O3.to_f/160
	zonghezhishu_value 
end

def get_month_zonghezhishu(id)
	#计算综合指数 需要6项指标的数据,so2,no2,pm10,pm25月均值，co第95百分位，o3第90百分位
	#先将当天的数据存储到数据库，再调用综合指数计算方法
	#年平均二级标准SO2:60,NO2:40,PM10:70,PM2.5:35
	#二级标准:CO 24小时平均4,O3日最大8小时平均160
	#参数
	#id=城市id
	dayCity=DayCity.new 
	time=Time.now()

	#指标数组，暂存数据进行处理
	so2_array=Array.new
	no2_array=Array.new
	pm10_array=Array.new
	pm25_array=Array.new
	co_array=Array.new
	o3_array=Array.new

	#遍历当月从1号到当天，获取数据
	second_in_day=60*60*24
	first_day=time.beginning_of_month()
	this_day=time.yesterday().end_of_day()
	while first_day<=this_day do
		temp_day=first_day+second_in_day
		dayCity=DayCity.where(["created_at >= ? AND created_at <= ?",first_day.to_date,temp_day.to_date])	
		first_day=temp_day
		if dayCity.nil?
			next
		else
			so2_array  << day_city.SO2.to_f
			no2_array << day_city.NO2.to_f
			pm10_array << day_city.pm10.to_f
			pm25_array << day_city.pm25.to_f
			co_array << day_city.CO.to_f
			o3_array << day_city.O3.to_f
		end
	end
	avg_so2=0
	avg_no2=0
	avg_pm10=0
	avg_pm25=0
	end_number=so2_array.length-1
	(0..end_number).each do |i|
		avg_so2 += so2_array [i]
		avg_no2 += no2_array[i]
		avg_pm10 += pm10_array[i]
		avg_pm25 += pm25_array[i]
	end
	#计算月均值
	avg_so2/=end_number
	avg_no2/=end_number
	avg_pm10/=end_number
	avg_pm25/=end_number

	#co o3百分位数计算
	co_array = co_array.sort_by{|x| x.to_f}
	o3_array = o3_array.sort_by{|x| x.to_f}

	co_index=(co_array.length()*0.95).floor
	o3_index=(o3_array.length()*0.9).floor

	zonghezhishu_value=avg_so2.to_f/60+avg_no2.to_f/40+avg_pm10.to_f/70+avg_pm25.to_f/35+co_array[co_index+1].to_f/4+o3_array[o3_index+1].to_f/160
	zonghezhishu_value
end

def get_year_zonghezhishu(id)
	#计算综合指数 需要6项指标的数据,so2,no2,pm10,pm25年均值，co年总天数第95百分位，o3年总天数第90百分位
	#参数
	#id=城市id
	dayCity=Daycity.new
	time=Time.now()

	#指标数组，暂存数据进行处理
	so2_array=Array.new
	no2_array=Array.new
	pm10_array=Array.new
	pm25_array=Array.new
	co_array=Array.new
	o3_array=Array.new

	#遍历当月从1号到当天，获取数据
	second_in_day=60*60*24
	first_day=time.beginning_of_year()
	this_day=time.end_of_day()
	while first_day<=this_day do
		temp_day=first_day+sec ond_in_day
		dayCity=Day_city.where(["created_at >= ? AND created_at <= ?",params[:first_day],params[:temp_day]])	
		first_day=temp_day
		if dayCity.nil?
			next
		else
			so2_array << day_city.SO2.to_f
			no2_array << day_city.NO2.to_f
			pm10_array << day_city.pm10.to_f
			pm25_array << day_city.pm25.to_f
			co_array << day_city.CO.to_f
			o3_array << day_city.O3.to_f
		end
	end
	avg_so2=0
	avg_no2=0
	avg_pm10=0
	avg_pm25=0
	end_number=so2_array.length-1
	(0..end_number).each do |i|
		avg_so2 += so2_array[i]
		avg_no2 += no2_array[i]
		avg_pm10 += pm10_array[i]
		avg_pm25 += pm25_array[i]
	end
	#计算年均值
	avg_so2/=end_number
	avg_no2/=end_number
	avg_pm10/=end_number
	avg_pm25/=end_number

	#co o3百分位数计算
	co_array = co_array.sort_by{|x| x.to_f}
	o3_array = o3_array.sort_by{|x| x.to_f}

	co_index=(co_array.length()*0.95).floor
	o3_index=(o3_array.length()*0.9).floor

	zonghezhishu_value=avg_so2.to_f/60+avg_no2.to_f/40+avg_pm10.to_f/70+avg_pm25.to_f/35+co_array[co_index+1].to_f/4+o3_array[o3_index+1].to_f/160
	return zonghezhishu_value
end

#计算同期对比
def get_change_rate(flag,id)
	time=Time.now.yesterday
	stime=time.beginning_of_day
	etime=time.end_of_day
	sql_str='["created_at >= ? AND created_at <= ?",stime.years_ago(1).to_date,etime.years_ago(1).to_date]'
	last_years=get_db_data(flag,'where',sql_str)
	sql_str='["created_at >= ? AND created_at <= ?",stime.to_date,etime.to_date]'
	now_years=get_db_data(flag,'where',sql_str)

	hs=Hash.new
	hs[:SO2]=(now_years.SO2-last_years.SO2)/last_years.SO2
	hs[:NO2]=(now_years.NO2-last_years.NO2)/last_years.NO2
	hs[:pm10]=(now_years.pm10-last_years.pm10)/last_years.pm10
	hs[:pm25]=(now_years.pm25-last_years.pm25)/last_years.pm25
	hs[:CO]=(now_years.CO-last_years.CO)/last_years.CO
	hs[:O3]=(now_years.O3-last_years.O3)/last_years.O3
	hs[:zhzs]=(now_years.zonghezhishu-last_years.zonghezhishu)/last_years.zonghezhishu
	hs

end
#start
main_get
#002号错误，计算综合指数时未在数据库中查找到数据
