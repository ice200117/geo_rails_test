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
	when 'temp_hb_hours'
		case table_operation
		when 'new'
			tabledata=TempHbHour.new	
		when 'all'
			tabledata=TempHbHour.all
		when 'last'
			tabledata=TempHbHour.last
		when 'where'
			tabledata=TempHbHour.where(table_operation_string)	
		end
	when 'temp_sfcities_hours'
		case table_operation
		when 'new'
			tabledata=TempSfcitiesHour.new	
		when 'all'
			tabledata=TempSfcitiesHour.all
		when 'last'
			tabledata=TempSfcitiesHour.last
		when 'where'
			tabledata=TempSfcitiesHour.where(table_operation_string)	
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
		puts response.body
		puts json_data
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
		puts t['city'] 
		city_array = City.where("city_name like ?",t['city']+'_')
		if city_array.length==0
			city_array=City.where("city_name = ?",t['city'])
		end
		city=city_array[0]
		day_city=get_db_data(flag,'new','')	
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
