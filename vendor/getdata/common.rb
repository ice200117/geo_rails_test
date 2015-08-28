require_relative './common.rb'
#数据库二次封装
def get_db_data(name,keyword,select_string)
	tabledata=Object.new
	select_string = nil if select_string == ''
	case name
	when 'day_city'
		tabledata = DayCity.send(keyword,select_string)
	when 'temp_lf_hours'
		tabledata = TempLfHour.send(keyword,select_string)
	when 'temp_lf_days'
		tabledata = TempLfDay.send(keyword,select_string)
	when 'temp_lf_months'
		tabledata = TempLfMonth.send(keyword,select_string)
	when 'temp_lf_years'
		tabledata = TempLfYear.send(keyword,select_string)
	when 'temp_hb_hours'
		tabledata = TempHbHour.send(keyword,select_string)
	when 'temp_jjj_days'
		tabledata = TempJjjDay.send(keyword,select_string)
	when 'temp_jjj_months'
		tabledata = TempJjjMonth.send(keyword,select_string)
	when 'temp_jjj_years'
		tabledata = TempJjjYear.send(keyword,select_string)
	when 'temp_bd_hours'
		tabledata = TempBdHour.send(keyword,select_string)
	when 'temp_bd_days'
		tabledata = TempBdDay.send(keyword,select_string)
	when 'temp_bd_months'
		tabledata = TempBdMonth.send(keyword,select_string)
	when 'temp_bd_years'
		tabledata = TempBdYear.send(keyword,select_string)
	when 'temp_sfcities_hours'
		tabledata = TempSfcitiesHour.send(keyword,select_string)
	when 'temp_sfcities_days'
		tabledata = TempSfcitiesDay.send(keyword,select_string)
	when 'temp_sfcities_months'
		tabledata = TempSfcitiesMonth.send(keyword,select_string)
	when 'temp_sfcities_years'
		tabledata = TempSfcitiesYear.send(keyword,select_string)
	end
	tabledata	
end

#参数
#web_flag:接口区别标志
#secretstr:城市选择， 
#typestr:数据类型  
#datestr：日期  格式(YYYY-MM-DD)
def get_rank_json(web_flag,secretstr,typestr,datestr)
	datestr=datestr.strftime("%Y-%m-%d") if datestr!=''
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
			hs[:cities] = column_name_modify(json_data['rows'])
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
#接口中不符合统一字段名，进行处理后再使用
def column_name_modify(hs)
	for i in (0..hs.length)
		hs[i]['city']=hs[i]['city_name'] if hs[i]['city_name']!=nil
		hs[i]['so2']=hs[i]['so2nd'] if hs[i]['so2nd']!=nil
		hs[i]['no2']=hs[i]['no2nd'] if hs[i]['no2nd']!=nil
		hs[i]['co']=hs[i]['cond'] if hs[i]['cond']!=nil
		hs[i]['o3']=hs[i]['o3nd'] if hs[i]['o3']!=nil
		hs[i]['pm10']=hs[i]['pm10'] if hs[i]['pm10']!=nil
		hs[i]['pm2_5']=hs[i]['pm2_5'] if hs[i]['pm2_5']!=nil
	end
	hs
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
#获取月平均数
def get_avg_by_month(flag,id,time)
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

	name=/\_(\w*)\_/.match(flag)
	flag="temp_#{name[1]}_days"

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
			if !day_city.SO2.nil? && day_city.SO2!=0
				so2_array<<day_city.SO2
			end
			if !day_city.NO2.nil? && day_city.NO2!=0
				no2_array<<day_city.NO2
			end
			if !day_city.pm10.nil? && day_city.pm10!=0
				pm10_array<<day_city.pm10
			end
			if !day_city.pm25.nil? && day_city.pm25!=0
				pm25_array<<day_city.pm25
			end
			if !day_city.CO.nil? && day_city.CO!=0
				co_array<<day_city.CO
			end
			if !day_city.O3.nil? && day_city!=0
				o3_array<<day_city.O3
			end
		end
		first_day=temp_day
	end
	avg_co=percentile(co_array,0.95).to_f
	avg_o3=percentile(o3_array,0.9).to_f

	hs=Hash.new
	hs['so2']=avg(so2_array)
	hs['no2']=avg(no2_array)
	hs['pm10']=avg(pm10_array)
	hs['pm2_5']=avg(pm25_array)
	hs['co']=avg_co
	hs['o3']=avg_o3
	hs
end
#获取年平均数
def get_avg_by_year(flag,id,time)
	second_in_day=60*60*24

	#指标数组，暂存数据进行处理
	so2_array=Array.new
	no2_array=Array.new
	pm10_array=Array.new
	pm25_array=Array.new
	co_array=Array.new
	o3_array=Array.new

	#遍历当月从1号到当天，获取数据
	first_day=time.to_time.beginning_of_year
	this_day=time.to_time.end_of_day

	name=/\_(\w*)\_/.match(flag)
	flag="temp_#{name[1]}_days"

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
			if !day_city.SO2.nil? && day_city.SO2!=0
				so2_array<<day_city.SO2
			end
			if !day_city.NO2.nil? && day_city.NO2!=0
				no2_array<<day_city.NO2
			end
			if !day_city.pm10.nil? && day_city.pm10!=0
				pm10_array<<day_city.pm10
			end
			if !day_city.pm25.nil? && day_city.pm25!=0
				pm25_array<<day_city.pm25
			end
			if !day_city.CO.nil? && day_city.CO!=0
				co_array<<day_city.CO
			end
			if !day_city.O3.nil? && day_city!=0
				o3_array<<day_city.O3
			end
		end
		first_day=temp_day
	end
	avg_co=percentile(co_array,0.95).to_f
	avg_o3=percentile(o3_array,0.9).to_f

	hs=Hash.new
	hs['so2']=avg(so2_array)
	hs['no2']=avg(no2_array)
	hs['pm10']=avg(pm10_array)
	hs['pm2_5']=avg(pm25_array)
	hs['co']=avg_co
	hs['o3']=avg_o3
	hs
end
#计算平均值
def avg(array)
	sum = 0
	array.each{|x| sum+=x}
	sum/array.length if array.length!=0
end
#百分位计算
def percentile(array,num)
	#co o3百分位数计
	array = array.sort
	ind=array.length*num
	(ind.is_a?Float) ? array[ind.floor].to_f : (array[ind].to_f+array[ind+1].to_f)/2
end

#计算同期对比
def get_change_rate(flag,id,time)
	sql_str=Array.new
	sql_str<<'data_real_time >= ? AND data_real_time <= ? AND city_id = ?'
	sql_str<<time.to_time.years_ago(1).beginning_of_day
	sql_str<<time.to_time.years_ago(1).end_of_day
	sql_str<<id
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
#调用接口最多进行10次尝试，如有数据则返回数据，没有数据返回false
def ten_times_test(flag,url,secret,type,date)
	hs=Hash.new
	(0..10).each do
		hs=get_rank_json(url,secret,type,date)  
		break if hs!=false
	end
	out_log(Time.now.to_s+" "+flag+"ERROR！") if hs == false
	out_log(Time.now.to_s+" "+flag+"total is 0");hs=false if hs[:total].to_i==0
	hs
end
#脚本异常返回日志
def out_log(log_string)
	this_log = Logger.new("/vagrant/geo_rails_test/log/getdata.log")
	this_log.info(log_string)
end
#与数据库不一直字段处理
def change_diff_column(hs,flag)
	if flag=='temp_lf_days'
		for i in (0..hs[:cities].length)
			hs[:cities][i]['city']='廊坊开发区' if hs[:cities][i]['city']='市辖区'
			hs[:cities][i]['city']='大厂' if hs[:cities][i]['city']='大厂回族自治县'
		end
	end
	hs
end
