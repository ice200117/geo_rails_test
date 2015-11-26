require_relative './city_enum.rb'
def get_rank_json(web_flag,secretstr,typestr,datestr)
	datestr=datestr.strftime("%Y-%m-%d") if datestr != nil
	methodstr = ''
	if secretstr.class == Hash
		methodstr=secretstr[:method]
		secretstr=secretstr[:secret]
	end
	hs = Hash.new
	begin
		if web_flag == 'shishi_china_rank_data'
			#真气网74城市实时/日排名
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
		elsif web_flag == 'all_city_by_hour'
			#全国城市小时数据
			option = {secret:secretstr,method:methodstr,type:typestr,key:Digest::MD5.hexdigest(secretstr+methodstr+typestr) }
			response = HTTParty.post('http://www.izhenqi.cn/api/dataapi.php',:body => option)
			Base64.decode64(response.body)
		end
		# byebug
		# f=File.open("/vagrant/geo_rails_test/vendor/test.txt",'w')
		# f.puts(Base64.decode64(response.body))
		# f.close
		json_data = ''
		if web_flag == 'all_city_by_hour'
			json_data=JSON.parse(Base64.decode64(response.body))
		else
			json_data=JSON.parse(response.body)
		end
		json_data['date'] != nil ? hs[:time] = json_data['date'] : hs[:time] = json_data['time']
		hs[:cities] = column_name_modify(json_data['rows'])
		hs[:total]=json_data['total']
	rescue
		hs=false
	end 
	hs
end
#接口中不符合统一字段名，进行处理后再使用
def column_name_modify(hs)
	for i in (0...hs.length)
		hs[i]['city']=hs[i]['city_name'] if hs[i]['city_name']!=nil
		hs[i]['so2']=hs[i]['so2nd'] if hs[i]['so2nd']!=nil
		hs[i]['no2']=hs[i]['no2nd'] if hs[i]['no2nd']!=nil
		hs[i]['co']=hs[i]['cond'] if hs[i]['cond']!=nil
		hs[i]['o3']=hs[i]['o3_8hnd'] if hs[i]['o3_8hnd']!=nil
		hs[i]['o3']=hs[i]['o3_8h'] if hs[i]['o3_8h'] != nil
		hs[i]['pm2_5']=hs[i]['pm25nd'] if hs[i]['pm25nd'] != nil
		hs[i]['pm10'] = hs[i]['pm10nd'] if hs[i]['pm10nd'] != nil
	end
	hs
end

#计算综合指数 需要6项指标的数据
#先将当天的数据存储到数据库，再调用综合指数计算方法
#年平均二级标准SO2:60,NO2:40,PM10:70,PM2.5:35
#二级标准:CO 24小时平均4,O3日最大8小时平均160
#参数
#id=城市id
def get_zonghezhishu(model)
	dayCity=model.last
	tmp = dayCity.SO2.to_f/60+dayCity.NO2.to_f/40+dayCity.pm10.to_f/70+dayCity.pm25.to_f/35+dayCity.CO.to_f/4+dayCity.O3.to_f/160
	tmp
end

#获取月年平均数
def get_avg(model,id,time)
	second_in_day=60*60*24

	#判断年还是月，设置日model
	name=/Temp(\w*)(Month|Year)/.match(model.name)
	if name[2] == 'Month'
		first_day=time.to_time.beginning_of_month
	else
		first_day = time.to_time.beginning_of_year
	end
	this_day = time.to_time.end_of_day

	days_model_name = "Temp#{name[1]}Day".constantize

	#指标数组，暂存数据进行处理
	so2_array=Array.new
	no2_array=Array.new
	pm10_array=Array.new
	pm25_array=Array.new
	co_array=Array.new
	o3_array=Array.new

	#获取数据begin
	sql_str = Array.new
	sql_str<<"data_real_time >=? AND data_real_time <=? AND city_id=?"
	sql_str<<first_day
	sql_str<<this_day
	sql_str<<id
	data_hs = days_model_name.where(sql_str).group_by(&:data_real_time)
	data_hs.each do |k,v|
		day_city = v[0]
		so2_array << day_city.SO2 if !day_city.SO2.nil? && day_city.SO2!=0
		no2_array << day_city.NO2 if !day_city.NO2.nil? && day_city.NO2!=0
		pm10_array << day_city.pm10 if !day_city.pm10.nil? && day_city.pm10!=0
		pm25_array << day_city.pm25 if !day_city.pm25.nil? && day_city.pm25!=0
		co_array << day_city.CO if !day_city.CO.nil? && day_city.CO != 0
		o3_array << day_city.O3 if !day_city.O3.nil? && day_city.O3 != 0
	end
	#end
=begin
	while first_day<=this_day do
		temp_day=first_day+second_in_day
		sql_str=Array.new
		sql_str<<"data_real_time >=? AND data_real_time <=? AND city_id=?"
		sql_str<<first_day
		sql_str<<temp_day
		sql_str<<id
		daycity=days_model_name.where(sql_str)	
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
=end
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
	sum/array.length if array.length != 0
end
#百分位计算
def percentile(array,num)
	#co o3百分位数计
	array = array.sort
	ind=array.length*num
	(ind.is_a?Float) ? array[ind.floor].to_f : (array[ind].to_f+array[ind+1].to_f)/2
end

#计算同期对比
def get_change_rate(model,id,time)
	sql_str=Array.new
	sql_str<<'data_real_time >= ? AND data_real_time <= ? AND city_id = ?'
	sql_str<<time.to_time.years_ago(1).beginning_of_day
	sql_str<<time.to_time.years_ago(1).end_of_day
	sql_str<<id
	last_years_data = model.where(sql_str)	
	if last_years_data.length == 0
		return false
	end
	last_years=last_years_data[0]

	now_years = model.last

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

#保存同期对比
def set_change_rate_to_db(model,id,time)
	day_city = model.last
	if day_city.data_real_time.year.to_i>2014.to_i 
		change_rate = get_change_rate(model,id,time)
		return if !change_rate
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

#调用接口最多进行10次尝试，如有数据则返回数据，没有数据返回false
def ten_times_test(model,url,secret,type,date)
	hs=Hash.new
	(0..10).each do
		hs=get_rank_json(url,secret,type,date)  
		break if hs!=false
	end
	if hs == false
		out_log(Time.now.to_s+" "+model.name+"ERROR！")
	elsif hs[:total].to_i == 0
		out_log(Time.now.to_s+" "+model.name+"total is 0")
		hs=false
	end
	hs
end

#脚本异常返回日志
def out_log(log_string)
	this_log = Logger.new("/vagrant/geo_rails_test/log/getdata.log")
	this_log.info(log_string)
end

#与数据库不一致字段处理
def change_diff_cityname(hs)
	for i in (0...hs[:cities].length)
		hs[:cities][i]['city']='廊坊开发区' if hs[:cities][i]['city'] =='市辖区'
		hs[:cities][i]['city']='大厂' if hs[:cities][i]['city'] =='大厂回族自治县'
	end
	hs
end

#保存数据
def save_db(hs,model)
	hs[:cities].each do |t|
		save_db_common(model,t,hs[:time])
	end
end

#保存数据到数据库
def save_db_common(model,t,time)
	out_log(t['city']) if t['city'].size <3
	city = City.find_by_city_name(t['city'].to_s+'市')
	city = City.find_by_city_name(t['city']) if city.nil?
	city = City.find_by_city_name(CityEnum.all_city(t['city'])) if city.nil?
	return if city.nil?	
	day_city=model.new
	day_city.city_id=city.id
	day_city.SO2=t['so2'] if t['so2'] != nil
	day_city.NO2=t['no2'] if t['no2'] != nil
	day_city.CO=t['co'] if t['co'] != nil
	day_city.O3 = t['o3'] if t['o3'] != nil
	day_city.pm10=t['pm10'] if t['pm10'] != nil
	day_city.pm25=t['pm2_5'] if t['pm2_5'] != nil
	day_city.AQI = t['aqi'] if t['aqi'] != nil && day_city.respond_to?('AQI')
	day_city.level = t['quality'] if t['quality'] != nil && day_city.respond_to?('level')
	day_city.maxindex=t['maxindex'] if ['maxindex'] != nil && day_city.respond_to?('maxindex')
	day_city.main_pol=t['main_pollutant'] if ['main_pollutant'] != nil && day_city.respond_to?('main_pol')
	day_city.weather = t['weather'] if t['weather'] != nil && day_city.respond_to?('weather')
	day_city.temp = t['temp'] if t['temp'] != nil && day_city.respond_to?('temp')
	day_city.humi = t['humi'] if t['humi'] != nil && day_city.respond_to?('humi')
	day_city.winddirection=t['winddirection'] if t['winddirection'] != nil && day_city.respond_to?('winddirection')
	day_city.windspeed=t['windspeed'] if t['windspeed'] != nil && day_city.respond_to?('windspeed')
	time = t['time'].to_time.localtime if time.nil?
	day_city.data_real_time = time.to_time.localtime
	day_city.save

	if model.new.respond_to?('zonghezhishu')
		day_city = model.last
		#判断接口是否提供综合指数
		if t['complexindex'] != nil && t['complexindex'] != 0
			day_city.zonghezhishu = t['complexindex']
		else
			day_city.zonghezhishu = get_zonghezhishu(model)
		end
		day_city.save
		set_change_rate_to_db(model,city.id,time) if model.new.respond_to?("zongheindex_change_rate")
	end
	puts '=='+model.name+'=='+time.to_s+'=Save OK!==='
end

#通用方法
def common_get_month_year(city_list,model,time)
	CityEnum.send(city_list).each do |name|
		city = City.find_by_city_name(name)
		city = City.find_by_city_name(name.to_s+'市') if city.nil?
		tmp = get_avg(model,city.id,time)
		tmp['city'] = name
		save_db_common(model,tmp,time)
	end
end
