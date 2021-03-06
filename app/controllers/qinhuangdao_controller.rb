#class QinhuangdaoController < ApplicationController
class QinhuangdaoController < Casein::CaseinController

	#	caches_page :pinggu, :bar
	#cache_sweeper :welcome_sweeper

	layout 'qinhuangdao'

	include NumRu
	protect_from_forgery :except => [:get_forecast_baoding, :get_city_point]

	before_action :banner,only: [:pinggu,:rank1503,:forecast,:compare,:ltjc]
	before_action :get_forecast,only: [:pinggu,:forecast]

	def map
		system('ls')
		r = `rails r vendor/test.rb`
		# puts r
	end

	def visits_by_day
		id =  params[:city_id]
		visits = Visit.all
		if id == "1"
			@chart = Visit.group_by_day(:visited_at, format: "%B %d, %Y").count
		else
			@chart = Visit.pluck("country").uniq.map { |c| { name: c, data: visits.where(country: c).group_by_day(:visited_at, format: "%B %d, %Y").count } }
		end
		respond_to do |format|
			format.js   {}
			format.json {
				render json: @chart
			}
		end
	end

	def bar
		@diff_monitor_forecast = []
		if params[:c] 
			city_name = params[:c][:city_name]
			c = City.find_by_city_name(city_name)
			c = City.find_by_city_name(city_name+'市') unless c
			c = City.find_by city_name_pinyin: 'qinhuangdaoshi' unless c
			id = c.id
		else
			# Table 1: 全国城市当天监测与预报日均值差值
			(id = City.find_by city_name_pinyin: 'qinhuangdaoshi')
			monitor_today_avg = ChinaCitiesHour.today_avg
			forecast_today_avg = HourlyCityForecastAirQuality.today_avg
			monitor_today_avg.each do |k,v|
				next unless forecast_today_avg[k]
				d = monitor_today_avg[k] - forecast_today_avg[k].values[0]
				@diff_monitor_forecast << [ k, monitor_today_avg[k], forecast_today_avg[k].values[0], d.abs, forecast_today_avg[k].keys[0]]
			end
		end

		# Table 2: 城市监测与预报值小时值对比
		c = City.find(id)
		if params[:start_date] && params[:end_date]
			sd = Time.local(params[:start_date][:year].to_i, params[:start_date][:month].to_i, params[:start_date][:day].to_i)
			ed = Time.local(params[:end_date][:year].to_i, params[:end_date][:month].to_i, params[:end_date][:day].to_i,23)
			return 'error: start date can not later than end date!' if sd > ed
			hss = c.hourly_city_forecast_air_qualities.order(:publish_datetime).last(120)
			hs = []
			hss.each {|h| hs << h if h.forecast_datetime >= sd && h.forecast_datetime <= ed }
		else
			hs = c.hourly_city_forecast_air_qualities.order(:publish_datetime).last(120)
		end 

		md = c.china_cities_hours.where(data_real_time: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
		
		@chart = [{name: c.city_name, data: hs.map { |h| [ h.forecast_datetime,  h.AQI]} }]
		@chart << {name: '监测值', data: md.map { |h| [ h.data_real_time,  h.AQI] } }


		# Table 3: 过去一星期城市监测与预报值日均值对比
		@fore_group_day = {}

		# 获取过去几天的监测值
		@fore_group_day = ChinaCitiesHour.history_data(c, 6.days.ago.beginning_of_day)

		# 获取过去几天发布的预报值
		md = {}
		h = c.hourly_city_forecast_air_qualities.group(:publish_datetime).having("publish_datetime >= ?", 6.days.ago.beginning_of_day).group_by_day(:forecast_datetime).average(:AQI)
		h.each {|k,v| k.map!{|x| x.strftime("%d%b")}; md[k] = v.round}

		@fore_group_day.merge!(md)

		respond_to do |format|
			format.html { }
			format.js   { }
			format.json {
				render json: @diff_monitor_forecast
			}
		end
	end

	#显示分指数
	def subindex
		@diff_monitor_forecast = []
		@city_name=''
		id = 18
		if params[:c] 
			(id =  params[:c][:city_id]) 
		end

		# Table 1: 全国城市当天监测与预报日均值差值
		monitor_today_avg = ChinaCitiesHour.today_avg
		forecast_today_avg = HourlyCityForecastAirQuality.today_avg
		monitor_today_avg.each do |k,v|
			next unless forecast_today_avg[k]
			d = monitor_today_avg[k] - forecast_today_avg[k].values[0]
			@diff_monitor_forecast << [ k, monitor_today_avg[k], forecast_today_avg[k].values[0], d.abs, forecast_today_avg[k].keys[0]]
		end

		# Table 2: 城市监测与预报值小时值对比
		c = City.find(id)
		@city_name=c.city_name
		if params[:start_date] && params[:end_date]
			sd = Time.local(params[:start_date][:year].to_i, params[:start_date][:month].to_i, params[:start_date][:day].to_i)
			ed = Time.local(params[:end_date][:year].to_i, params[:end_date][:month].to_i, params[:end_date][:day].to_i,23)
			return 'error: start date can not later than end date!' if sd > ed
			hss = c.hourly_city_forecast_air_qualities.order(:publish_datetime).last(120)
			hs = []
			hss.each {|h| hs << h if h.forecast_datetime >= sd && h.forecast_datetime <= ed }
		else
			hs = c.hourly_city_forecast_air_qualities.order(:publish_datetime).last(120)
		end 

		md = c.china_cities_hours.where(data_real_time: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)

		@chart_aqi = [{name: '预报值', data: hs.map { |h| [ h.forecast_datetime, h.AQI]} }]
		@chart_aqi << {name: '监测值', data: md.map { |h| [ h.data_real_time,h.AQI ] } }

		@chart_so2 = [{name: '预报值', data: hs.map { |h| [ h.forecast_datetime,  h.SO2]} }]
		@chart_so2 << {name: '监测值', data: md.map { |h| [ h.data_real_time,  h.SO2] } }

		@chart_no2 = [{name: '预报值', data: hs.map { |h| [ h.forecast_datetime,  h.NO2]} }]
		@chart_no2 << {name: '监测值', data: md.map { |h| [ h.data_real_time,  h.NO2] } }

		@chart_co = [{name: '预报值', data: hs.map { |h| [ h.forecast_datetime,  h.CO]} }]
		@chart_co << {name:'监测值', data: md.map { |h| [ h.data_real_time,  h.CO] } }

		@chart_o3 = [{name: '预报值', data: hs.map { |h| [ h.forecast_datetime,  h.O3]} }]
		@chart_o3 << {name: '监测值', data: md.map { |h| [ h.data_real_time,  h.O3] } }

		@chart_pm10 = [{name: '预报值', data: hs.map { |h| [ h.forecast_datetime,  h.pm10]} }]
		@chart_pm10 << {name: '监测值', data: md.map { |h| [ h.data_real_time,  h.pm10]} }

		@chart_pm25 = [{name: '预报值', data: hs.map { |h| [ h.forecast_datetime,  h.pm25]} }]
		@chart_pm25 << {name: '监测值', data: md.map { |h| [ h.data_real_time,  h.pm25] } }

		@chart_vis = [{name: '预报值', data: hs.map { |h| [ h.forecast_datetime,  h.VIS]} }]
		# @chart_vis << {name: '监测值', data: md.map { |h| [ h.data_real_time,  h.VIS] } }

		# Table 3: 过去一星期城市监测与预报值日均值对比
		@fore_group_day = {}

		# 获取过去几天的监测值
		@fore_group_day = ChinaCitiesHour.history_data(c, 6.days.ago.beginning_of_day)

		# 获取过去几天发布的预报值
		md = {}
		h = c.hourly_city_forecast_air_qualities.group(:publish_datetime).having("publish_datetime >= ?", 6.days.ago.beginning_of_day).group_by_day(:forecast_datetime).average(:AQI)
		h.each {|k,v| k.map!{|x| x.strftime("%d%b")}; md[k] = v.round}

		@fore_group_day.merge!(md)
		respond_to do |format|
			format.html { }
			format.js   { }
			format.json {
				render json: @diff_monitor_forecast
			}
		end
	end

	def get_history_data
		model = params[:model]
		time = params[:time].to_time
		data = change_data_type(get_db_data(model.constantize,time),0)
		render :json=>data
	end

	#1.三组按钮组间关系：根据三组按钮之间的关系确定编程顺序，先通过判断按天还是按小时从而确定查询天表还是小时表
	#然后，通过第二组按钮最近一天、最近一周等等确定startdate和enddate今儿去卡记录数
	#最后，通过第一组按钮确定要显示的字段。
	#2.三组按钮组内关系：第一组：“综合”显示AQI和其他的一堆，“AQI”只显示AQI，“PM2.5”~“湿度”这些显示AQI和本身
	#第二组和第三组：如果选中“最近一天”则无论是按天还是按小时均按小时显示曲线图，如果选中“最近一周”、“最近一月”、“最近一年”则按天与按小时显示的图不同
=begin
	def chartway
		# citybd=City.find_by city_name: '保定市'
		startdate=Time.local(params[:starttime][0,4].to_i,params[:starttime][5,2].to_i,params[:starttime][8,2].to_i)
		enddate=Time.local(params[:endtime][0,4].to_i,params[:endtime][5,2].to_i,params[:endtime][8,2].to_i,23)
		if  params[:starttime]==params[:endtime] 
			startdate=Time.local(params[:starttime][0,4].to_i,params[:starttime][5,2].to_i,params[:starttime][8,2].to_i)
			enddate=Time.local(params[:endtime][0,4].to_i,params[:endtime][5,2].to_i,params[:endtime][8,2].to_i,23)
			querydata=TempSfcitiesHour.where("data_real_time>=? AND data_real_time<=? AND city_id=?",startdate,enddate,11) #秦皇岛的cityid是11,减少查找步骤，提高访问速度
		elsif params[:exact]=='eh'
			querydata=TempSfcitiesHour.where("data_real_time>=? AND data_real_time<=? AND city_id=?",startdate,enddate,11) 
		else
			querydata=TempSfcitiesDay.where("data_real_time>=? AND data_real_time<=? AND city_id=?",startdate,enddate,11)
		end  
		if params[:type]=='zonghe'
			@chartdata={categories: querydata.map{ |data| params[:exact]=='eh' ? data.data_real_time.strftime("%m-%d %H") : data.data_real_time.strftime("%Y-%m-%d")}, series: [{name: 'AQI',data: querydata.map{ |data| data.AQI}},{name: 'PM2.5(μg/m3)',data: querydata.map{ |data| data.pm25}},{name: 'PM10(μg/m3)',data: querydata.map{ |data| data.pm10}},{name: 'SO2(μg/m3)',data: querydata.map{ |data| data.SO2}},{name: 'CO(mg/m3)',data: querydata.map{ |data| data.CO}},{name: 'NO2(μg/m3)',data: querydata.map{ |data| data.NO2}},{name: 'O3(μg/m3)',data: querydata.map{ |data| data.O3}}]}
		elsif params[:type]=='PM25'
			@chartdata={categories: querydata.map{ |data| params[:exact]=='eh' ? data.data_real_time.strftime("%m-%d %H") : data.data_real_time.strftime("%Y-%m-%d")}, series: [{name: 'AQI',data: querydata.map{ |data| data.AQI}},{name: 'PM2.5(μg/m3)',data: querydata.map{ |data| data.pm25}}]}
		elsif params[:type]=='PM10'
			@chartdata={categories: querydata.map{ |data| params[:exact]=='eh' ? data.data_real_time.strftime("%m-%d %H") : data.data_real_time.strftime("%Y-%m-%d")}, series: [{name: 'AQI',data: querydata.map{ |data| data.AQI}},{name: 'PM10(μg/m3)',data: querydata.map{ |data| data.pm10}}]}
		elsif params[:type]=='SO2'
			@chartdata={categories: querydata.map{ |data| params[:exact]=='eh' ? data.data_real_time.strftime("%m-%d %H") : data.data_real_time.strftime("%Y-%m-%d")}, series: [{name: 'AQI',data: querydata.map{ |data| data.AQI}},{name: 'SO2(μg/m3)',data: querydata.map{ |data| data.SO2}}]}
		elsif params[:type]=='NO2'
			@chartdata={categories: querydata.map{ |data| params[:exact]=='eh' ? data.data_real_time.strftime("%m-%d %H") : data.data_real_time.strftime("%Y-%m-%d")}, series: [{name: 'AQI',data: querydata.map{ |data| data.AQI}},{name: 'NO2(μg/m3)',data: querydata.map{ |data| data.NO2}}]}
		elsif params[:type]=='CO'
			@chartdata={categories: querydata.map{ |data| params[:exact]=='eh' ? data.data_real_time.strftime("%m-%d %H") : data.data_real_time.strftime("%Y-%m-%d")}, series: [{name: 'AQI',data: querydata.map{ |data| data.AQI}},{name: 'CO(mg/m3)',data: querydata.map{ |data| data.CO}}]}
		elsif params[:type]=='O3'
			@chartdata={categories: querydata.map{ |data| params[:exact]=='eh' ? data.data_real_time.strftime("%m-%d %H") : data.data_real_time.strftime("%Y-%m-%d")}, series: [{name: 'AQI',data: querydata.map{ |data| data.AQI}},{name: 'O3(μg/m3)',data: querydata.map{ |data| data.O3}}]}
		elsif params[:type]=='tem' && params[:exact]=='eh'
			@chartdata={categories: querydata.map{ |data| params[:exact]=='eh' ? data.data_real_time.strftime("%m-%d %H") : data.data_real_time.strftime("%Y-%m-%d")}, series: [{name: 'AQI',data: querydata.map{ |data| data.AQI}},{name: '温度(℃)',data: querydata.map{ |data| data.temp}}]}
		elsif params[:type]=='wind' && params[:exact]=='eh'
			@chartdata={categories: querydata.map{ |data| params[:exact]=='eh' ? data.data_real_time.strftime("%m-%d %H") : data.data_real_time.strftime("%Y-%m-%d")}, series: [{name: 'AQI',data: querydata.map{ |data| data.AQI}},{name: '风速(级)',data: querydata.map{ |data| data.windspeed}}]}
		elsif params[:type]=='hum' && params[:exact]=='eh'
			@chartdata={categories: querydata.map{ |data| params[:exact]=='eh' ? data.data_real_time.strftime("%m-%d %H") : data.data_real_time.strftime("%Y-%m-%d")}, series: [{name: 'AQI',data: querydata.map{ |data| data.AQI}},{name: '湿度(%)',data: querydata.map{ |data| data.humi}}]}
		else
			@chartdata={categories: querydata.map{ |data| params[:exact]=='eh' ? data.data_real_time.strftime("%m-%d %H") : data.data_real_time.strftime("%Y-%m-%d")}, series: [{name: 'AQI',data: querydata.map{ |data| data.AQI}}]}
		end
		respond_to do |format|
			format.html { }
			format.js   { }
			format.json {
				render json: @chartdata
			}
		end
	end
=end

	def get_linechart_data
		city=City.find_by city_name: (params[:city]+'市')
		startdate=Time.local(params[:startTime][0,4].to_i,params[:startTime][5,2].to_i,params[:startTime][8,2].to_i,0)
		enddate=Time.local(params[:endTime][0,4].to_i,params[:endTime][5,2].to_i,params[:endTime][8,2].to_i,23)
		if params[:type]=='HOUR'
			querydata=TempSfcitiesHour.where("data_real_time>=? AND data_real_time<=? AND city_id=?",startdate,enddate,city.id).order('data_real_time asc') 
		elsif params[:type]=='DAY'
			querydata=TempSfcitiesDay.where("data_real_time>=? AND data_real_time<=? AND city_id=?",startdate,enddate,city.id).order('data_real_time asc')
		else
			querydata=TempSfcitiesMonth.where("data_real_time>=? AND data_real_time<=? AND city_id=?",startdate,enddate,city.id).order('data_real_time asc')      
		end  
		@linechartdata={total: querydata.size,rows: querydata.map{ |data| { aqi: data.AQI,co: data.CO,complexindex: data.zonghezhishu,humi: data.humi,no2: data.NO2,o3: data.O3,pm2_5: data.pm25,pm10: data.pm10,primary_pollutant: data.main_pol,so2: data.SO2,temp: data.temp,time: data.data_real_time.strftime("%Y-%m-%d %H:%M:%S"),weather: data.weather,winddirection: data.winddirection,windlevel: data.windscale}}}

		respond_to do |format|
			format.html { }
			format.js   { }
			format.json {
				render json: @linechartdata
			}
		end    
	end






	def sfcities_compare_chart
		#以下方式City表中所有城市均适用
		citynamearray=Array[params[:city1],params[:city2],params[:city3]]
		cityidarray=Array.new
		citynamearray.each do |cityname|
			city=City.find_by city_name: cityname
			if city!=nil
				cityidarray << city.id
			else
				city=City.where("city_name LIKE ?",[cityname,'%'].join)
				cityidarray << city[0].id		
			end
		end
		#以上方式City表中所有城市均适用
		startdate=Time.local(params[:startTime][0,4].to_i,params[:startTime][5,2].to_i,params[:startTime][8,2].to_i,0)
		enddate=Time.local(params[:endTime][0,4].to_i,params[:endTime][5,2].to_i,params[:endTime][8,2].to_i,23)
		if params[:type]=='HOUR'
			querydata=TempSfcitiesHour.where("data_real_time>=? AND data_real_time<=? AND city_id IN (?)",startdate,enddate,cityidarray).order('data_real_time asc') 
		elsif params[:type]=='DAY'
			querydata=TempSfcitiesDay.where("data_real_time>=? AND data_real_time<=? AND city_id IN (?)",startdate,enddate,cityidarray).order('data_real_time asc')
		else
			querydata=TempSfcitiesMonth.where("data_real_time>=? AND data_real_time<=? AND city_id IN (?)",startdate,enddate,cityidarray).order('data_real_time asc')      
		end  
		@citycompare={citynum: cityidarray,rows: querydata.map{ |data| { alldata: data,timeformatted: data.data_real_time.strftime("%Y-%m-%d %H:%M:%S")}}}
		#pp querydata.map{ |data| data.city_id}.uniq.length
		#pp @citycompare
		respond_to do |format|
			format.html { }
			format.js   { }
			format.json {
				render json: @citycompare
			}
		end    
	end


	def qhdqx_compare_chart

		bdqx_monitorpoint={"海港建设大厦"=>"建设大厦","北戴河区"=>"北戴河","海关区"=>"第一关","海港市政府"=>"市政府","青龙满族自治县"=>"青龙环保局","昌黎县"=>"昌黎环保局","抚宁县"=>"抚宁党校","卢龙县"=>"卢龙县气象局","海港市监测站"=>"市监测站"}
		city1=MonitorPoint.where("pointname =? AND city_id = 11",bdqx_monitorpoint[params[:city1]])
		city2=MonitorPoint.where("pointname =? AND city_id = 11",bdqx_monitorpoint[params[:city2]])
		city3=MonitorPoint.where("pointname =? AND city_id = 11",bdqx_monitorpoint[params[:city3]])
		cityidarray=Array[city1[0].id,city2[0].id,city3[0].id]
		startdate=Time.local(params[:startTime][0,4].to_i,params[:startTime][5,2].to_i,params[:startTime][8,2].to_i,0)
		enddate=Time.local(params[:endTime][0,4].to_i,params[:endTime][5,2].to_i,params[:endTime][8,2].to_i,23)
		if params[:type]=='HOUR'
			querydata=MonitorPointHour.where("data_real_time>=? AND data_real_time<=? AND monitor_point_id IN (?,?,?)",startdate,enddate,city1[0].id,city2[0].id,city3[0].id).order('data_real_time asc') 
		elsif params[:type]=='DAY'
			querydata=MonitorPointDay.where("data_real_time>=? AND data_real_time<=? AND monitor_point_id IN (?,?,?)",startdate,enddate,city1[0].id,city2[0].id,city3[0].id).order('data_real_time asc')
		else
			querydata=MonitorPointMonth.where("data_real_time>=? AND data_real_time<=? AND monitor_point_id IN (?,?,?)",startdate,enddate,city1[0].id,city2[0].id,city3[0].id).order('data_real_time asc')      
		end  
		@bdqxcompare={citynum: cityidarray,rows: querydata.map{ |data| { alldata: data,timeformatted: data.data_real_time.strftime("%Y-%m-%d %H:%M:%S")}}}
		#pp querydata.map{ |data| data.city_id}.uniq.length
		#pp @citycompare
		respond_to do |format|
			format.html { }
			format.js   { }
			format.json {
				render json: @bdqxcompare
			}
		end    
	end


	def sourceAnalysisPieChart
				
		city=City.find_by city_name: (params[:city]+'市')
		querytime=Time.local(params[:datetime][0,4].to_i,params[:datetime][5,2].to_i,params[:datetime][8,2].to_i,params[:datetime][11,2].to_i)
		querydata=TempSfcitiesHour.where("city_id=? AND data_real_time=?",city.id,querytime)
		@_3Dpiechartdata=[["PM2.5",((querydata[0].pm25)/35/(querydata[0].zonghezhishu))*100],['PM10',((querydata[0].pm10)/70/(querydata[0].zonghezhishu))*100],['SO2',((querydata[0].SO2)/60/(querydata[0].zonghezhishu))*100],['NO2',((querydata[0].NO2)/40/(querydata[0].zonghezhishu))*100],['CO',((querydata[0].CO)/4/(querydata[0].zonghezhishu))*100],['O3',((querydata[0].O3)/160/(querydata[0].zonghezhishu))*100]]
		render layout: '3Dpiechart'
	end



	def pinggu
		#秦皇岛数据
		# @bddatabyhour=del_some_points(change_data_type(get_db_data(TempBdHour,TempBdHour.last.data_real_time))) 
		@qhdbyday=change_data_type(MonitorPointDay.new.yesterday_by_cityid(11),1)
		# @qhdbymonth=change_data_type(MonitorPointMonth.new.yesterday_by_cityid(11),1)
		# @qhdbyyear=change_data_type(MonitorPointYear.new.yesterday_by_cityid(11),1)
		@qhdbyhour=change_data_type(MonitorPointHour.new.last_hour_by_cityid(11),1)

		#河北数据
		@hebeidatabyhour=change_data_type(get_db_data(TempHbHour,TempHbHour.last.data_real_time),0) 
		hebeidatabyday=change_data_type(get_db_data(TempJjjDay,TempJjjDay.last.data_real_time),0)
		hebeidatabyday[:cities] = hebeidatabyday[:cities].delete_if{|item| (item['city']=='北京')||(item['city']=='天津')}
		@hebeidatabyday=hebeidatabyday

		#京津冀
		@jjjdatabyday=change_data_type(get_db_data(TempJjjDay,TempJjjDay.last.data_real_time),0)
		@jjjdatabymonth=change_data_type(get_db_data(TempJjjMonth,TempJjjMonth.last.data_real_time),0)
		@jjjdatabyyear=change_data_type(get_db_data(TempJjjYear,TempJjjYear.last.data_real_time),0)

		#74城市
		@sfcitiesrankbyhour=get_db_data(TempSfcitiesHour,TempSfcitiesHour.last.data_real_time)
		@sfcitiesrankbyday=change_data_type(change_74_main_pol(get_db_data(TempSfcitiesDay,TempSfcitiesDay.last.data_real_time)),0)
		@sfcitiesrankbymonth=change_data_type(get_db_data(TempSfcitiesMonth,TempSfcitiesMonth.last.data_real_time),0)
		@sfcitiesrankbyyear=change_data_type(get_db_data(TempSfcitiesYear,TempSfcitiesYear.last.data_real_time),0)
		# adj data
		@city_adj = 'ADJ_baoding/'

	end
	def get_rank(data)
		data.each do |l|
			return l['rank'] if l['city_id'] == 11
		end
	end

	#修改74城市首要污染物
	def change_74_main_pol(hs)
		main_pol={"二氧化氮"=>"NO2","臭氧8小时"=>"O3","二氧化硫"=>"SO2","一氧化碳"=>"CO","细颗粒物"=>"PM2.5","颗粒物"=>"PM10"}
		for i in (0...hs.length)
			tmp = ''
			n = 0 
			main_pol.each do |key,value|
				if /\w*(#{key})\w*/.match(hs[i]['main_pol'])
					tmp += "," if n != 0
					tmp += value
					n += 1
				end
			end
			hs[i]['main_pol'] = tmp
		end		
		hs
	end

	#获取数据库数据pinggu.html.erb显示
	def get_db_data(model,time)
		stime = nil
		etime = nil
		if /\w*Hour/.match(model.name)
			stime = time.beginning_of_hour
			etime = time.end_of_hour
		else
			stime = time.beginning_of_day
			etime = time.end_of_day
		end
		if Custom::Redis.get(model.name).nil?
			data = model.where(data_real_time:(stime..etime))
			tmpd = /\w*Hour/.match(model.name) ? 3600 : 3600*24
			Custom::Redis.set(model.name,data,tmpd)
		else
			Custom::Redis.get(model.name)
		end
	end

	#修改小数点位数
	def change_data_type(data,flag)			
		#设置需要处理小数位数的字段
		float_round={"SO2"=>0,"NO2"=>0,"CO"=>1,"O3"=>0,"pm10"=>0,"pm25"=>0,"zonghezhishu"=>2,"AQI"=>0,
			   "SO2_change_rate"=>4,"NO2_change_rate"=>4,"CO_change_rate"=>4,"O3_change_rate"=>4,"pm10_change_rate"=>4,
			   "pm25_change_rate"=>4,"zongheindex_change_rate"=>4}
		model_column=Array['level','main_pol','data_real_time','maxindex']
		data_ary=Array.new
		(0...data.length).each do |t|
			data_hash=Hash.new
			if flag == 0
				data_hash['city']=City.find(data[t]['city_id']).city_name
			elsif flag == 1
				data_hash['city']=MonitorPoint.find(data[t]['monitor_point_id']).pointname
			end
			float_round.each do |k,v|
				if /change_rate/.match(k)
					d="%.#{v}f"%data[t][k].to_f if data[t][k]!=nil
					d.to_f>0 ? data_hash['img']='arrow_up' : data_hash['img']='arrow_down'
					data_hash[k]=(d.to_f*100).abs.round(v).to_s
				else
					data_hash[k]="%.#{v}f"%data[t][k].to_f if data[t][k] != nil
				end
			end
			model_column.each do |i|
				data_hash[i]=data[t][i]
			end
			data_ary[t]=data_hash
		end
		re_hs=Hash.new
		if data[0]
			re_hs[:time]=data[0]['data_real_time']
		else
			re_hs[:time]=Time.now
		end
		re_hs[:cities]=data_ary
		re_hs
	end

	#获取预测数据
	def get_forecast
		city_name_encode = ERB::Util.url_encode("秦皇岛")
		options = Hash.new
		headers={'apikey' => 'f8484c1661a905c5ca470b0d90af8d9f'}
		options[:headers] = headers
		url = "http://apis.baidu.com/showapi_open_bus/weather_showapi/address?area=#{city_name_encode}&needMoreDay=1"
		response = HTTParty.get(url,options)
		json = JSON.parse(response.body)
		# puts 0 if json['showapi_res_error'] == 0
		@forecast_data = Hash.new
		json['showapi_res_body'].each do |k,v|
			if k[-1].to_i > 0 
				tq = get_tq(v)
				@forecast_data[tq['day']] = tq
			end
		end
		temp = HourlyCityForecastAirQuality.new.air_quality_forecast('qinhuangdaoshi')


		temp.each do |k,v|
			v["fore_lev"] = get_lev(v["AQI"])
			key = k.to_time.strftime("%Y%m%d")
			if @forecast_data[key] != nil
				@forecast_data[key]=@forecast_data[key].merge(v)
			end
		end
		# @ret=@weather
	end
	#天气处理与get_forecast合作使用
	def get_tq(f1)
		tq = Hash.new
		tq['tq'] = f1['day_weather']
		if f1['day_air_temperature'][-1] == '℃'
			tq['temp1'] = f1['day_air_temperature'][0,f1['day_air_temperature'].size-1]
		else
			tq['temp1'] = f1['day_air_temperature'] 
		end
		tq['temp2'] = f1['night_air_temperature']
		if f1['day_wind_direction'] == '无持续风向' && f1['night_wind_direction'] == '无持续风向'
			tq['wd'] = f1['day_wind_direction']
		elsif f1['day_wind_direction'] != '无持续风向' && f1['night_wind_direction'] == '无持续风向'
			tq['wd'] = f1['day_wind_direction']
		elsif f1['day_wind_direction'] == '无持续风向' && f1['night_wind_direction'] != '无持续风向'
			tq['wd'] = f1['night_wind_direction']
		elsif f1['day_wind_direction'] != '无持续风向' && f1['night_wind_direction'] != '无持续风向'
			if f1['day_wind_direction'] == f1['night_wind_direction'] 
				tq['wd'] = f1['day_wind_direction']
			elsif f1['day_wind_direction'] != f1['night_wind_direction'] 
				# tq['wd'] = f1['day_wind_direction']+'~'+f1['night_wind_direction']
			end
		end
		dw = f1['day_wind_power']
		nw = f1['night_wind_power']
		def wind_power(wp)
			return '' unless wp
			return wp[0,2] if wp[0,2] == '微风'
			for e in (0...wp.size)
				return wp[0,e+1] if wp[e] == '级'
			end		
		end
		dw = wind_power(dw)
		nw = wind_power(nw)
		if dw == nw
			tq['ws'] = dw
		elsif dw != nw
			dw[0].to_i > nw[0].to_i ? tq['ws'] = nw + '~' + dw : tq['ws'] = dw + '~' + nw
		end
		date = f1['day'].to_time
		if date.day==Time.now.day
			tq['date']= date.month.to_s.to_s+date.strftime("月%d日")+' '+'今天'
		elsif date.day==1.days.from_now.day
			tq['date']= date.month.to_s.to_s+date.strftime("月%d日")+' '+'明天'
		elsif date.day==2.days.from_now.day
			tq['date']= date.month.to_s.to_s+date.strftime("月%d日")+' '+'后天'
		else
			tq['date']= date.month.to_s.to_s+date.strftime("月%d日")+' '+'星期'+Custom::Week.week_of_time(date)
		end
		tq['day'] = f1['day'].to_time.strftime("%Y%m%d")
		tq
	end
	#获取预测数据
	def get_forecast_baoding
		data = get_forecast()

		respond_to do |format|
			format.html { render json: data }
			if params[:callback] #jsonp回调函数名
				format.js { render :json => data, :callback => params[:callback] }
			else
				format.json { render json: data}
			end
		end
	end

	#获取城市名称和经纬度
	def get_city_point
		pointdata=City.all.map{ |data| { city_name: data.city_name,longitude: data.longitude,latitude: data.latitude} }
		respond_to do |format|
			format.html { render json: pointdata}
			if params[:callback] #jsonp回调函数名
				format.js { render :json => pointdata, :callback => params[:callback] }
			else
				format.json { render json: pointdata}
			end
		end
	end

=begin
	def get_lev_old(a)
		if (0 .. 50) === a
			lev = 'you'
		elsif (50 .. 100) === a
			lev = 'yellow'
		elsif (100 .. 150) === a
			lev = 'qingdu'
		elsif (150 .. 200) === a
			lev = 'zhong'
		elsif (200 .. 300) === a
			lev = 'zhongdu'
		elsif (300 .. 500) === a
			lev = 'yanzhong'
		end
	end
=end

	def get_lev(aqi)
		if aqi<=0
			lev='yichang'
		elsif aqi<=50
			lev = 'you'
		elsif aqi<=100
			lev = 'yellow'
		elsif aqi<=150
			lev = 'qingdu'
		elsif aqi<=200
			lev = 'zhong'
		elsif aqi<=300
			lev = 'zhongdu'
		else
			lev = 'yanzhong'	
		end
	end

	def getlevelColor(level)
		if level==0
	     lev='yichang'
	   	elsif level==1
	     lev = 'you'
	   	elsif level==2
	    lev = 'yellow'
	   	elsif level==3
	    lev = 'qingdu'
	   	elsif level==4
	    lev = 'zhong'
	   	elsif level==5
	    lev = 'zhongdu'
	   	else
	    lev = 'yanzhong'
		end
	end

	def getPM25LevelIndex(pm2_5)
		if pm2_5<=35
	      level=1
	    elsif pm2_5<=75
	      level=2
	    elsif pm2_5<=115
	      level=3
	    elsif pm2_5<150
	      level=4
	    elsif pm2_5<=250
	      level=5
	    else
	      level=6
		end	
	end

	def getPM10LevelIndex(pm10)
	    if pm10<=50
	      level=1
	    elsif pm10<=150
	      level=2
	    elsif pm10<=250
	      level=3
	    elsif pm10<350
	      level=4
	    elsif pm10<=420
	      level=5
	    else
	      level=6
	    end	
	end

	def getSO2LevelIndex(so2)
		if so2<=150
	      level=1
	    elsif so2<=500
	      level=2
	    elsif so2<=650
	      level=3
	    elsif so2<800
	      level=4
	    else
	      level=5
		end
	end

	def getCOLevelIndex(co)
		if co<=5
	      level=1
	    elsif co<=10
	      level=2
	    elsif co<=35
	      level=3
	    elsif co<60
	      level=4
	    elsif co<90
	      level=5
	    else
	      level=6
		end
	end

	def getNO2LevelIndex(no2)
		if no2<=100
		      level=1
		    elsif no2<=200
		      level=2
		    elsif no2<=700
		      level=3
		    elsif no2<1200
		      level=4
		    elsif no2<2340
		      level=5
		    else
		      level=6
		end
	end

    def getO3LevelIndex(o3)
    	if o3<=160
	      level=1
	    elsif o3<=200
	      level=2
	    elsif o3<=300
	      level=3
	    elsif o3<400
	      level=4
	    elsif o3<800
	      level=5
	    else
	      level=6
    	end
    end

    def getPointIcon(str,main_pol)
    	return (main_pol.include? str) ? 'point_icon8x8.jpg' : ''  	
    end

	def hb_real
		hs = Hash.new
		begin
			response = HTTParty.get('http://www.izhenqi.cn/api/getdata_cityrank.php?secret=CHINARANK&type=HOUR&key='+Digest::MD5.hexdigest('CHINARANKHOUR'))
			d = JSON.parse(response.body)
			hs[:time] = (d['time']).to_time
			hs[:cities] =  d['rows']
		rescue
			puts 'Can not get data from izhenqi, please check network!'
		end
		hs
	end

	CITY_LIST = [
		"public/adj/baoding.txt",
		"public/adj/beijing.txt",
		"public/adj/cangzhou.txt",
		"public/adj/chengde.txt",
		"public/adj/handan.txt",
		"public/adj/hengshui.txt",
		"public/adj/langfang.txt",
		"public/adj/qinhuangdao.txt",
		"public/adj/shijiazhuang.txt",
		"public/adj/tangshan.txt",
		"public/adj/tianjin.txt",
		"public/adj/xingtai.txt",
		"public/adj/zhangjiakou.txt"
	]
	CL = [
		"保定",
		"北京",
		"沧州",
		"承德",
		"邯郸",
		"衡水",
		"廊坊",
		"秦皇岛",
		"石家庄",
		"唐山",
		"天津",
		"邢台",
		"张家口" 
	]

	CITY_LIST_QHD = [
		"public/adj/qhd/baoding.txt",
		"public/adj/qhd/beijing.txt",
		"public/adj/qhd/cangzhou.txt",
		"public/adj/qhd/chengde.txt",
		"public/adj/qhd/handan.txt",
		"public/adj/qhd/hengshui.txt",
		"public/adj/qhd/langfang.txt",
		"public/adj/qhd/qinhuangdao.txt",
		"public/adj/qhd/shijiazhuang.txt",
		"public/adj/qhd/tangshan.txt",
		"public/adj/qhd/tianjin.txt",
		"public/adj/qhd/xingtai.txt",
		"public/adj/qhd/zhangjiakou.txt"
	]
	CL_QHD = [
		"保定",
		"北京",
		"沧州",
		"承德",
		"邯郸",
		"衡水",
		"廊坊",
		"秦皇岛",
		"石家庄",
		"唐山",
		"天津",
		"邢台",
		"张家口" 
	]


	CITY_LIST_ZZ = [
		"public/adj/zz/anyang.txt",
		"public/adj/zz/hebi.txt",
		"public/adj/zz/jiaozuo.txt",
		"public/adj/zz/kaifeng.txt",
		"public/adj/zz/luohe.txt",
		"public/adj/zz/luoyang.txt",
		"public/adj/zz/nanyang.txt",
		"public/adj/zz/pingdingshan.txt",
		"public/adj/zz/sanmenxia.txt",
		"public/adj/zz/shangqiu.txt",
		"public/adj/zz/xinxiang.txt",
		"public/adj/zz/xinyang.txt",
		"public/adj/zz/xuchang.txt",
		"public/adj/zz/zhengzhou.txt",
		"public/adj/zz/zhoukou.txt",
		"public/adj/zz/zhumadian.txt",
		"public/adj/zz/puyang.txt"
	]
	CL_ZZ = [
		"安阳",
		"鹤壁",
		"焦作",
		"开封",
		"漯河",
		"洛阳",
		"南阳",
		"平顶山",
		"三门峡",
		"商丘",
		"新乡",
		"信阳",
		"许昌",
		"郑州",
		"周口",
		"驻马店",
		"濮阳"
	]

	def adj_pie
		city_dir = 'ADJ_baoding'
		force = "bd"
		if params[:city_name]
			if params[:city_name] == 'baodingshi'
				city_dir = 'ADJ_baoding' 
				force ="bd"
			elsif params[:city_name] == 'zhengzhoushi'
				city_dir = 'ADJ_zhengzhou'
				force ="zz"
			elsif params[:city_name] == 'qinhuangdaoshi'
				city_dir = 'ADJ_qinhuangdao'
				force ="qhd"
			end
		end
		adj_bd = {}
		var_list = ["CO_120", "NOX_120", "SO2_120"]
		var_list.each { |var_name|
			adj_per = adj_percent(var_name,city_dir,force)
			adj_bd[var_name] = adj_per
		}
		respond_to do |format|
			format.json   {
				render json: adj_bd
			}
		end
	end

	def adj_percent(type="", city='ADJ_baoding', force = "bd")
		nt = Time.now
		i = 0
		#path = 'public/images/ftproot/Temp/Backup'+city+'/'
		path = '/mnt/share/Temp/Backup'+city+'/'
		begin
			#puts i
			strtime = (nt-60*60*24*i).strftime("%Y-%m-%d")
			ncfile = path + 'CUACE_09km_adj_'+strtime+'.nc'
			#ncfile='public\images\CUACE_09km_adj_2015-06-27.nc'
			i = i + 1
			return {} if i>356
		end until File::exists?(ncfile)

		#ncfile = 'public/adj/CUACE_09km_adj_2015-06-08.nc'

		#puts ncfile
		if type==""
			var_list = ["CO_120", "NOX_120", "SO2_120"]
		else
			var_list = [type]
		end
		adj_per = {}
		var_list.each { |var_name|
			pl = (cal_var ncfile, var_name, force)
			# puts var_name
			pl.sort.reverse.each { |p|
				#print CL[pl.index(p)], "   ", p, "\n"
				if force == "bd"
					adj_per[CL[pl.index(p)]] = p.round(2) if p.round(1) > 0.03
				elsif force == "zz"
					adj_per[CL_ZZ[pl.index(p)]] = p.round(2) if p.round(1) > 0.03
				elsif force == "qhd"
					adj_per[CL_QHD[pl.index(p)]] = p.round(2) if p.round(1) > 0.03
				end
			}
		}
		adj_per
	end

	def adj_ajax
		@type = params[:type] if params[:type]
		post = params[:post] if params[:post]
		case post
		when '130600'
			@city_adj = 'ADJ_baoding/'
		when '130300'
			@city_adj = 'ADJ_qinhuangdao/'
			force = 'qhd'
		else
			@city_adj = 'ADJ/'
		end

		@adj_per = adj_percent(@type, @city_adj, force)
		respond_to do |format|
			format.js   {
				# puts @adj_per
			}
		end
	end

	def cal_var ( ncfile, var_name, force)
		pl = Array.new
		if force == "bd" then
			CITY_LIST.each { |city_file|
				pl << (read_adj ncfile, city_file, var_name)
			}
		elsif force == "zz" then
			CITY_LIST_ZZ.each { |city_file|
				pl << (read_adj ncfile, city_file, var_name)
			}
		elsif force == "qhd" then
			CITY_LIST_QHD.each { |city_file|
				pl << (read_adj ncfile, city_file, var_name)
			}
		end
		return pl
	end

	def read_adj (ncfile, city_file, var_name)
		file = NetCDF.open(ncfile)

		# Get longitude
		var = file.var(var_name)
		data = var.get
		#puts data.shape

		x = Array.new
		y = Array.new
		#puts city_file
		lines = IO.readlines(city_file)
		num_points = lines.length - 1
		#lines.each { |line|
		for i in 1..lines.length-1
			as = lines[i].split(pattern=' ') 
			x << as[0].to_i - 1
			y << as[1].to_i - 1
		end
		#}

		sum_per = 0.0
		for i in 0..num_points-1
			#puts data[x[i],y[i],0,0]
			sum_per += data[x[i],y[i],0,0]
		end
		return sum_per
	end

	#74城市全部展示
	def rank1503
		#74城市
		@sfcitiesrankbyday=change_data_type(get_db_data(TempSfcitiesDay),0)
		@sfcitiesrankbymonth=change_data_type(get_db_data(TempSfcitiesMonth),0)
		@sfcitiesrankbyyear=change_data_type(get_db_data(TempSfcitiesYear),0)
	end

	def forecast
		@day_fdata = @banner["day_fdata"]
		@post='130300'
		@city_adj = @banner["city_adj"]
		@adj_per1 = @banner["adj_per1"]
	end

	def ltjc

	end
	def compare
	end
	def sfcities_compare
		render layout: getlayoutbyaction('sfcities_compare')
	end


	def qhdqx_compare
		render layout: getlayoutbyaction('qhdqx_compare')
	end


	def getlayoutbyaction(action_name)
		if action_name == 'sfcities_compare' || action_name == 'qhdqx_compare'
			layout='cmp'
		end
		layout
	end

	def banner
		hs = Hash.new
		# monitor data
		md = hb_real
		hs['rt']= md[:time]
		md[:cities].each do |c|
			if c['city'] == '秦皇岛'
				hs = hs.merge(c)
				break
			end
		end
		# forecast data
		aqis = []
		pri_pol = []
		ch=nil

		unless Custom::Redis.get('qhd_hour_forecast')
			c = City.find_by_city_name_pinyin('qinhuangdaoshi')
			ch = c.hourly_city_forecast_air_qualities.order(:publish_datetime).last(120).group_by_day(&:forecast_datetime)
			Custom::Redis.set('qhd_hour_forecast',ch,3600*24)
		else
			ch = Custom::Redis.get('qhd_hour_forecast')
		end

		ch.each do |time,fds|
			t = Time.now
			if time > Time.local(t.year,t.month,t.day)
				#if time >= Time.local(2015,4,24)
				sum = []
				fds.each do |fd|
					sum << fd['AQI']
				end
				aqis << [sum.min, sum.max]
				pri_pol << fds[0]['main_pol']
			end
		end

		lev_hs = {"you"=>"优", "yellow"=>"良", "qingdu"=>"轻度", "zhong"=>"中度","zhongdu"=>"重度", "yanzhong"=>"严重","yichang"=>"异常值"}

		hs["lev"] = get_lev(hs["aqi"])
		hs["lev_han"] = lev_hs[hs["lev"]]
		hs["pm2_5_color"]=getlevelColor(getPM25LevelIndex(hs["pm2_5"]))
		hs["pm10_color"]=getlevelColor(getPM10LevelIndex(hs["pm10"]))
		hs["so2_color"]=getlevelColor(getSO2LevelIndex(hs["so2"]))
		hs["co_color"]=getlevelColor(getCOLevelIndex(hs["co"]))
		hs["no2_color"]=getlevelColor(getNO2LevelIndex(hs["no2"]))
		hs["o3_color"]=getlevelColor(getO3LevelIndex(hs["o3"]))

		if hs['main_pollutant']==nil || hs['main_pollutant']==""
		hs['pm2_5_icon']=''
		hs['pm10_icon']=''
		hs['so2_icon']=''
		hs['co_icon']=''
		hs['no2_icon']=''
		hs['o3_icon']=''
		else
				
		hs['pm2_5_icon']=getPointIcon('PM2.5',hs['main_pollutant'])
		hs['pm10_icon']=getPointIcon('PM10',hs['main_pollutant'])
		hs['so2_icon']=getPointIcon('SO2',hs['main_pollutant'])
		hs['co_icon']=getPointIcon('CO',hs['main_pollutant'])
		hs['no2_icon']=getPointIcon('NO2',hs['main_pollutant'])
		hs['o3_icon']=getPointIcon('O3',hs['main_pollutant'])
        end
		lev_arr = []
		lev_han_arr= []
		aqis.each do |aqi|
			lev_arr << {start:get_lev(aqi[0]),end:get_lev(aqi[1])}
			lev_han_arr << {start:lev_hs[get_lev(aqi[0])],end:lev_hs[get_lev(aqi[1])]}
		end

		week_hs = ["星期日", "星期一","星期二","星期三","星期四","星期五","星期六"]

		t = (Time.now + 60*60*24*3).strftime('%w').to_i
		t1 = (Time.now + 60*60*24*4).strftime('%w').to_i
		td = ['今天','明天','后天',week_hs[t], week_hs[t1]]

		day_fdata = []
		lev_arr.each_with_index do |lev,i|
			day_fdata << {w:td[i], start:lev[:start], end:lev[:end], start_han:lev_han_arr[i][:start], end_han:lev_han_arr[i][:end],pol:pri_pol[i]}
		end
		hs["day_fdata"] = day_fdata
		#实时天气预报
		begin
			response = HTTParty.get('http://www.weather.com.cn/adat/sk/101091101.html')	
			json_data = JSON.parse(response.body)
			hs = hs.merge(json_data['weatherinfo'])	
		rescue
			hs['real_time_weather'] = false	
		end

		hs["city_adj"] = 'ADJ_qinhuangdao/'
		force = 'qhd'
		hs["adj_per1"] = adj_percent('SO2_120', hs["city_adj"], force)

		city_name_pinyin='qinhuangdaoshi'
		@rank={'hour'=>(75-TempSfcitiesHour.city_rank(city_name_pinyin))}
		@rank['day']=75-TempSfcitiesDay.city_rank(city_name_pinyin)
		@rank['month']=75-TempSfcitiesMonth.city_rank(city_name_pinyin)
		@rank['year']=75-TempSfcitiesYear.city_rank(city_name_pinyin)
		@banner = hs
	end 
	#周边城市
	def cities_around_fun
		cities_hash={1=>"北京",8=>"天津",10=>"唐山",18=>"廊坊",14=>"保定",56=>"葫芦岛",49=>"锦州",16=>"承德"}
		stime = ChinaCitiesHour.last.data_real_time.beginning_of_hour
		etime = stime.end_of_hour
		# starttime=Time.mktime((Time.now-3600).year,(Time.now-3600).month,(Time.now-3600).day,(Time.now-3600).hour,0,0)
		# endtime=Time.mktime((Time.now-3600).year,(Time.now-3600).month,(Time.now-3600).day,(Time.now-3600).hour,59,59)
		querydata=ChinaCitiesHour.where("data_real_time>=? AND data_real_time<=? AND city_id IN (1,8,10,18,14,56,49,16)",stime,etime).order(AQI: :desc)
		@cities_around=querydata.map{ |data| { time: data.data_real_time.strftime("%Y-%m-%d %H:%M:%S"),cityname: cities_hash[data.city_id],aqi: data.AQI,pm2_5: data.pm25,pm10: data.pm10,so2: data.SO2,no2: data.NO2,co: data.CO,o3: data.O3,quality: data.level,primary_pollutant: data.main_pol,weather: data.weather,temp: data.temp,humi: data.humi,windspeed: data.windspeed,winddirection: data.winddirection}}
		respond_to do |format|
			format.html { }
			format.js   { }
			format.json {
				render json: @cities_around
			}
		end
	end
	def get_rank_chart_data
		cityName = params[:city]+"市"
		type = params[:type]
		stime = params[:startTime].to_time
		etime = params[:endTime].to_time
		@get_rank_chart_data = nil
		if type == 'DAY'
			@get_rank_chart_data = TempSfcitiesDay.get_rank_chart_data(cityName,stime,etime)
		else
			@get_rank_chart_data = TempSfcitiesMonth.get_rank_chart_data(cityName,stime,etime)
		end
		respond_to do |format|
			format.html {}
			format.js {}
			format.json{ render json: @get_rank_chart_data}
		end
	end
end
