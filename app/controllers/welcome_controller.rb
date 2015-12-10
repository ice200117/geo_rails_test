class WelcomeController < ApplicationController
	include NumRu
	protect_from_forgery :except => [:get_forecast_baoding, :get_city_point]


	def index
		#data_table = GoogleVisualr::DataTable.new
		#data_table.new_column('string', 'Country')
		#data_table.new_column('number', 'Popularity')
		#data_table.add_rows(6)
		#data_table.set_cell(0, 0, 'Germany')
		#data_table.set_cell(0, 1, 200)
		#data_table.set_cell(1, 0, 'United States')
		#data_table.set_cell(1, 1, 300)
		#data_table.set_cell(2, 0, 'Brazil')
		#data_table.set_cell(2, 1, 400)
		#data_table.set_cell(3, 0, 'Canada')
		#data_table.set_cell(3, 1, 500)
		#data_table.set_cell(4, 0, 'France')
		#data_table.set_cell(4, 1, 600)
		#data_table.set_cell(5, 0, 'RU')
		#data_table.set_cell(5, 1, 700)

		#opts   = { :width => 500, :height => 300 }
		#@chart = GoogleVisualr::Interactive::GeoChart.new(data_table, opts)

		#data_table_markers = GoogleVisualr::DataTable.new
		#data_table_markers.new_column('string'  , 'Country'   )
		#data_table_markers.new_column('number'  , 'Popularity')
		#data_table_markers.add_rows(6)
		#data_table_markers.set_cell(0, 0, 'New York'     )
		#data_table_markers.set_cell(0, 1, 200)
		#data_table_markers.set_cell(1, 0, 'Boston'       )
		#data_table_markers.set_cell(1, 1, 300)
		#data_table_markers.set_cell(2, 0, 'Miami'        )
		#data_table_markers.set_cell(2, 1, 400)
		#data_table_markers.set_cell(3, 0, 'Chicago'      )
		#data_table_markers.set_cell(3, 1, 500)
		#data_table_markers.set_cell(4, 0, 'Los Angeles'  )
		#data_table_markers.set_cell(4, 1, 600)
		#data_table_markers.set_cell(5, 0, 'Houston'      )
		#data_table_markers.set_cell(5, 1, 700)

		#opts   = {  :region => 'US'  }
		#@chart = GoogleVisualr::Interactive::GeoChart.new(data_table_markers, opts)

		#data_table = GoogleVisualr::DataTable.new
		#data_table.new_column('number', 'Lat' )
		#data_table.new_column('number', 'Lon' )
		#data_table.new_column('string', 'Name')
		#data_table.add_rows(4)
		#data_table.set_cell(0, 0, 37.4232   )
		#data_table.set_cell(0, 1, -122.0853 )
		#data_table.set_cell(0, 2, 'Work'      )
		#data_table.set_cell(1, 0, 37.4289   )
		#data_table.set_cell(1, 1, -122.1697 )
		#data_table.set_cell(1, 2, 'University')
		#data_table.set_cell(2, 0, 37.6153   )
		#data_table.set_cell(2, 1, -122.3900 )
		#data_table.set_cell(2, 2, 'Airport'   )
		#data_table.set_cell(3, 0, 37.4422   )
		#data_table.set_cell(3, 1, -122.1731 )
		#data_table.set_cell(3, 2, 'Shopping'  )
		#opts   = { :showTip => true }
		#@chart = GoogleVisualr::Interactive::Map.new(data_table, opts)
	end
	def show
		# @visits = Visit.all
	end 

	def map
		#respond_to do |format|
		#format.js   {}
		#format.html   {}
		#format.json {
		#achf = Hash.new
		#cs = City.all
		#cs.each do |c|
		#ch = c.hourly_city_forecast_air_qualities.last(120)[0]
		#achf[c.city_name] = ch.AQI  if ch
		#end
		#render json: achf
		#}
		#end

		system('ls')
		r = `rails r vendor/test.rb`
		puts r
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
			(id =  params[:c][:city_id]) 
		else
      # Table 1: 全国城市当天监测与预报日均值差值
			(id = City.find_by city_name_pinyin: 'langfangshi')
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
			hss = c.hourly_city_forecast_air_qualities.last(120)
			hs = []
			hss.each {|h| hs << h if h.forecast_datetime >= sd && h.forecast_datetime <= ed }
		else
			hs = c.hourly_city_forecast_air_qualities.last(120)
		end 

		md = c.china_cities_hours.where(data_real_time: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
		@chart = [{name: c.city_name, data: hs.map { |h| [ h.forecast_datetime,  h.AQI]} }]
		@chart << {name: '监测值', data: md.map { |h| [ h.data_real_time,  h.AQI] } }


    # Table 3: 过去一星期城市监测与预报值日均值对比
		@fore_group_day = {}
		h = c.hourly_city_forecast_air_qualities.group(:publish_datetime).having("publish_datetime >= ?", 6.days.ago.beginning_of_day).group_by_day(:forecast_datetime).average(:AQI)
    h.each {|k,v| k.map!{|x| x.strftime("%d%b")}; @fore_group_day[k] = v.round}

		# 获取过去几天的监测值
		md = ChinaCitiesHour.history_data(c, 6.days.ago.beginning_of_day)
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
		data = change_data_type(get_db_data(model.constantize,time))
		render :json=>data
	end

	#1.三组按钮组间关系：根据三组按钮之间的关系确定编程顺序，先通过判断按天还是按小时从而确定查询天表还是小时表
	#然后，通过第二组按钮最近一天、最近一周等等确定startdate和enddate今儿去卡记录数
	#最后，通过第一组按钮确定要显示的字段。
	#2.三组按钮组内关系：第一组：“综合”显示AQI和其他的一堆，“AQI”只显示AQI，“PM2.5”~“湿度”这些显示AQI和本身
	#第二组和第三组：如果选中“最近一天”则无论是按天还是按小时均按小时显示曲线图，如果选中“最近一周”、“最近一月”、“最近一年”则按天与按小时显示的图不同
	def chartway
		citybd=City.find_by city_name: '保定市'
		startdate=Time.local(params[:starttime][0,4].to_i,params[:starttime][5,2].to_i,params[:starttime][8,2].to_i)
		enddate=Time.local(params[:endtime][0,4].to_i,params[:endtime][5,2].to_i,params[:endtime][8,2].to_i,23)
		if  params[:starttime]==params[:endtime] 
			startdate=Time.local(params[:starttime][0,4].to_i,params[:starttime][5,2].to_i,params[:starttime][8,2].to_i)
			enddate=Time.local(params[:endtime][0,4].to_i,params[:endtime][5,2].to_i,params[:endtime][8,2].to_i,23)
			querydata=TempSfcitiesHour.where("data_real_time>=? AND data_real_time<=? AND city_id=?",startdate,enddate,citybd.id)
		elsif params[:exact]=='eh'
			querydata=TempSfcitiesHour.where("data_real_time>=? AND data_real_time<=? AND city_id=?",startdate,enddate,citybd.id) 
		else
			querydata=TempSfcitiesDay.where("data_real_time>=? AND data_real_time<=? AND city_id=?",startdate,enddate,citybd.id)
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
=begin
	def getwinddirectionurl(wd)
		wid = 0
		url = nil
		case wd
		when '东风'
			wid = 1
		when '东南风'
			wid = 2
		when '南风'
			wid = 3
		when '西南风'
			wid = 4
		when '西风'
			wid = 5
		when '西北风'
			wid = 6
		when '北风'
			wid = 7
		when '东北风'
			wid = 8
		end

		url = "<%= image_url 'winddirection/"+ wid +".png' %>" if wid>0
		url
	end

	def city_compare_chart
		city1=City.find_by city_name: (params[:city1]+"市") 
		city2=City.find_by city_name: (params[:city2]+"市")
		city3=City.find_by city_name: (params[:city3]+"市")
		cityarray=Array[city1,city2,city3]
		colorarry=Array['#3399CC','#D26900','#A5A552']
		counter=-1
		cityarray=cityarray.uniq

		startdate=Time.local(params[:starttime][0,4].to_i,params[:starttime][5,2].to_i,params[:starttime][8,2].to_i)
		enddate=Time.local(params[:endtime][0,4].to_i,params[:endtime][5,2].to_i,params[:endtime][8,2].to_i,23)
		if params[:exact]=='eh' || params[:starttime]==params[:endtime]
			querydata=TempSfcitiesHour.where("data_real_time>=? AND data_real_time<=? AND city_id IN (?,?,?)",startdate,enddate,city1.id,city2.id,city3.id) 
		else
			querydata=TempSfcitiesDay.where("data_real_time>=? AND data_real_time<=? AND city_id IN (?,?,?)",startdate,enddate,city1.id,city2.id,city3.id)
		end  
		if params[:type]=='temp'
			if data[params[:type]]>-100 && data[params[:type]]<200 
				@citycompare={series: cityarray.map{ |cityobj| {name: cityobj.city_name,data: querydata.map{ |data| {x: (data.data_real_time.to_f*1000).to_i,y: data[params[:type]]} if data.city_id==cityobj.id},color: colorarry[counter=counter+1]}}}
			end
		elsif params[:type]=='humi'
			if data[params[:type]]>0
				@citycompare={series: cityarray.map{ |cityobj| {name: cityobj.city_name,data: querydata.map{ |data| {x: (data.data_real_time.to_f*1000).to_i,y: data[params[:type]]} if data.city_id==cityobj.id},color: colorarry[counter=counter+1]}}}
			end
		elsif params[:type]=='windscale'
			if data[params[:type]]>0
				@citycompare={series: cityarray.map{ |cityobj| {name: cityobj.city_name,data: querydata.map{ |data| {x: (data.data_real_time.to_f*1000).to_i,y: data[params[:type]],marker: {symbol: getwinddirectionurl(data.winddirection)},winddirection: data.winddirection,weather: data.weather} if data.city_id==cityobj.id},color: colorarry[counter=counter+1]}}}
			end
		else
			@citycompare={series: cityarray.map{ |cityobj| {name: cityobj.city_name,data: querydata.map{ |data| {x: (data.data_real_time.to_f*1000).to_i,y: data[params[:type]]} if data.city_id==cityobj.id},color: colorarry[counter=counter+1]}}}
		end
		respond_to do |format|
			format.html { }
			format.js   { }
			format.json {
				render json: @citycompare
			}
		end    
	end
=end


	def city_compare_chart
		city1=City.find_by city_name: (params[:city1]+'市')
		city2=City.find_by city_name: (params[:city2]+'市')
		city3=City.find_by city_name: (params[:city3]+'市')
		cityidarray=Array[city1.id,city2.id,city3.id]
		startdate=Time.local(params[:startTime][0,4].to_i,params[:startTime][5,2].to_i,params[:startTime][8,2].to_i,0)
		enddate=Time.local(params[:endTime][0,4].to_i,params[:endTime][5,2].to_i,params[:endTime][8,2].to_i,23)
		if params[:type]=='HOUR'
			querydata=TempSfcitiesHour.where("data_real_time>=? AND data_real_time<=? AND city_id IN (?,?,?)",startdate,enddate,city1.id,city2.id,city3.id).order('data_real_time asc') 
		elsif params[:type]=='DAY'
			querydata=TempSfcitiesDay.where("data_real_time>=? AND data_real_time<=? AND city_id IN (?,?,?)",startdate,enddate,city1.id,city2.id,city3.id).order('data_real_time asc')
		else
			querydata=TempSfcitiesMonth.where("data_real_time>=? AND data_real_time<=? AND city_id IN (?,?,?)",startdate,enddate,city1.id,city2.id,city3.id).order('data_real_time asc')      
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


	def bdqx_compare_chart

		bdqx_monitorpoint={"白沟新城"=>"白沟新城行政中心楼","满城县"=>"满城税务局","清苑县"=>"清苑县政府","涞水县"=>"涞水县环境监测站","阜平县"=>"阜平县环保局","定兴县"=>"定兴县政府","高阳县"=>"高阳县环保局","容城县"=>"容城县环境保护局","涞源县"=>"涞源县环保局","望都县"=>"望都县环境监测站","安新县"=>"安新民政局","易县"=>"易县环境保护局","曲阳县"=>"曲阳县环保局","蠡县"=>"蠡县县政府","顺平县"=>"顺平县环保局","博野县"=>"博野县招生办","雄县"=>"雄县环境保护局","涿州市"=>"涿州监测站","安国市"=>"安国市政府","高碑店市"=>"高碑店环保局","徐水县"=>"徐水环保局","定州市"=>"定州武装部","唐县"=>"唐县政府楼"}
		city1=City.find_by city_name: bdqx_monitorpoint[params[:city1]]
		city2=City.find_by city_name: bdqx_monitorpoint[params[:city2]]
		city3=City.find_by city_name: bdqx_monitorpoint[params[:city3]]
		cityidarray=Array[city1.id,city2.id,city3.id]
		startdate=Time.local(params[:startTime][0,4].to_i,params[:startTime][5,2].to_i,params[:startTime][8,2].to_i,0)
		enddate=Time.local(params[:endTime][0,4].to_i,params[:endTime][5,2].to_i,params[:endTime][8,2].to_i,23)
		if params[:type]=='HOUR'
			querydata=TempBdHour.where("data_real_time>=? AND data_real_time<=? AND city_id IN (?,?,?)",startdate,enddate,city1.id,city2.id,city3.id).order('data_real_time asc') 
		elsif params[:type]=='DAY'
			querydata=TempBdDay.where("data_real_time>=? AND data_real_time<=? AND city_id IN (?,?,?)",startdate,enddate,city1.id,city2.id,city3.id).order('data_real_time asc')
		else
			querydata=TempBdMonth.where("data_real_time>=? AND data_real_time<=? AND city_id IN (?,?,?)",startdate,enddate,city1.id,city2.id,city3.id).order('data_real_time asc')      
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


	#去掉保定部分监测点
	def del_some_points(data)
		del_point=['地表水厂','游泳馆','接待中心', '华电二区', '定兴县政府', '市监测站', '胶片厂']
		del_point.each do |t|
			data[:cities].each do |n|
				data[:cities].delete(n) if n['city'].strip == t.strip 
			end
		end
		data
	end

	def pinggu
		#保定数据
		@bddatabyhour=del_some_points(change_data_type(get_db_data(TempBdHour,TempBdHour.last.data_real_time))) 
		@bddatabyday=del_some_points(change_data_type(get_db_data(TempBdDay,TempBdDay.last.data_real_time))) 
		@bddatabymonth=del_some_points(change_data_type(get_db_data(TempBdMonth,TempBdMonth.last.data_real_time)))
		@bddatabyyear=del_some_points(change_data_type(get_db_data(TempBdYear,TempBdYear.last.data_real_time)))

		#河北数据
		@hebeidatabyhour=change_data_type(get_db_data(TempHbHour,TempHbHour.last.data_real_time)) 
		hebeidatabyday=change_data_type(get_db_data(TempJjjDay,TempJjjDay.last.data_real_time))
		hebeidatabyday[:cities] = hebeidatabyday[:cities].delete_if{|item| (item['city']=='北京市')||(item['city']=='天津市')}
		@hebeidatabyday=hebeidatabyday

		#京津冀
		@jjjdatabyday=change_data_type(get_db_data(TempJjjDay,TempJjjDay.last.data_real_time))
		@jjjdatabymonth=change_data_type(get_db_data(TempJjjMonth,TempJjjMonth.last.data_real_time))
		@jjjdatabyyear=change_data_type(get_db_data(TempJjjYear,TempJjjYear.last.data_real_time))

		#74城市
		@sfcitiesrankbyday=change_data_type(change_74_main_pol(get_db_data(TempSfcitiesDay,TempSfcitiesDay.last.data_real_time)))
		@sfcitiesrankbymonth=change_data_type(get_db_data(TempSfcitiesMonth,TempSfcitiesMonth.last.data_real_time))
		@sfcitiesrankbyyear=change_data_type(get_db_data(TempSfcitiesYear,TempSfcitiesYear.last.data_real_time))

		@banner = banner()

		@forecast_data = get_forecast()

		# adj data
		@city_adj = 'ADJ_baoding/'

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
		sql_str=Array.new
		sql_str<<"data_real_time >= ? AND data_real_time <= ?"
		sql_str<<stime
		sql_str<<etime
		data = model.where(sql_str)
		data[0].nil? ? [] : data.uniq
	end

	#修改小数点位数
	def change_data_type(data)			
		float_round={"SO2"=>0,"NO2"=>0,"CO"=>1,"O3"=>0,"pm10"=>0,"pm25"=>0,"zonghezhishu"=>2,"AQI"=>0,
			   "SO2_change_rate"=>4,"NO2_change_rate"=>4,"CO_change_rate"=>4,"O3_change_rate"=>4,"pm10_change_rate"=>4,
			   "pm25_change_rate"=>4,"zongheindex_change_rate"=>4}
		model_column=Array['level','main_pol','data_real_time','maxindex']

		data_ary=Array.new
		(0...data.length).each do |t|
			data_hash=Hash.new
			data_hash['city']=City.find(data[t].city_id).city_name
			float_round.each do |k,v|
				if /change_rate/.match(k)
					d="%.#{v}f"%data[t][k].to_f if data[t].respond_to?(k)
					d.to_f>0 ? data_hash['img']='arrow_up' : data_hash['img']='arrow_down'
					data_hash[k]=(d.to_f*100).abs.round(v).to_s
				else
					data_hash[k]="%.#{v}f"%data[t][k].to_f if data[t].respond_to?(k)
				end
			end
			model_column.each do |i|
				data_hash[i]=data[t][i]
			end
			data_ary[t]=data_hash
		end
		re_hs=Hash.new
		if data[0]
			re_hs[:time]=data[0].data_real_time
		else
			re_hs[:time]=Time.now
		end
		re_hs[:cities]=data_ary
		re_hs
	end

	#获取预测数据
	def get_forecast
		city_name_encode = ERB::Util.url_encode("保定市")
		options = Hash.new
		headers={'apikey' => 'f8484c1661a905c5ca470b0d90af8d9f'}
		options[:headers] = headers
		url = "http://apis.baidu.com/showapi_open_bus/weather_showapi/address?area=#{city_name_encode}&needMoreDay=1"
		response = HTTParty.get(url,options)
		json = JSON.parse(response.body)
		puts 0 if json['showapi_res_error'] == 0
		@weather = Hash.new
		json['showapi_res_body'].each do |k,v|
			if k[-1].to_i > 0 
				tq = get_tq(v)
				@weather[tq['day']] = tq
			end
		end
		temp = HourlyCityForecastAirQuality.new.air_quality_forecast('baodingshi')
		@ret = {}
		temp.each do |k,v|
			v["fore_lev"] = get_lev(v["AQI"])
			time = k.strftime("%Y%m%d")
			if @weather[time] != nil
				@ret[time]=@weather[time].merge(v)
			end
		end
		@ret
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
				tq['wd'] = f1['day_wind_direction']+'~'+f1['night_wind_direction']
			end
		end
		dw = f1['day_wind_power']
		nw = f1['night_wind_power']
		def wind_power(wp)
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



	def get_lev(a)
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

	def adj_pie
		city_dir = 'ADJ_baoding'
		if params[:city_name]
			city_dir = 'ADJ_baoding' if params[:city_name] == 'baodingshi'
		end
		adj_bd = {}
		var_list = ["CO_120", "NOX_120", "SO2_120"]
		var_list.each { |var_name|
			adj_per = adj_percent(var_name,city_dir)
			adj_bd[var_name] = adj_per
		}
		respond_to do |format|
			format.json   {
				render json: adj_bd
			}
		end
	end
	def adj_percent(type="", city='ADJ_baoding')
		nt = Time.now
		i = 0
		path = 'public/images/ftproot/Temp/Backup'+city+'/'
		#path = '/mnt/share/Temp/Backup'+city+'/'
		begin
			#puts i
			strtime = (nt-60*60*24*i).strftime("%Y-%m-%d")
			ncfile = path + 'CUACE_09km_adj_'+strtime+'.nc'
			#ncfile='public\images\CUACE_09km_adj_2015-06-27.nc'
			i = i + 1
			return {} if i>60
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
			pl = (cal_var ncfile, var_name)
			# puts var_name
			pl.sort.reverse.each { |p|
				print CL[pl.index(p)], "   ", p, "\n"
				adj_per[CL[pl.index(p)]] = p.round(2) if p.round(1) > 0.03
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
		else
			@city_adj = 'ADJ/'
		end

		@adj_per = adj_percent(@type, @city_adj)
		respond_to do |format|
			format.js   {
				puts @adj_per
			}
		end
	end

	def cal_var ( ncfile, var_name )
		pl = Array.new
		CITY_LIST.each { |city_file|
			pl << (read_adj ncfile, city_file, var_name)
		}
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
		@sfcitiesrankbyday=change_data_type(get_db_data(TempSfcitiesDay))
		@sfcitiesrankbymonth=change_data_type(get_db_data(TempSfcitiesMonth))
		@sfcitiesrankbyyear=change_data_type(get_db_data(TempSfcitiesYear))
		@banner=banner()
	end

	def forecast
		@banner = banner()
		@day_fdata = @banner["day_fdata"]
		@post='130600'
		@city_adj = @banner["city_adj"]
		@adj_per1 = @banner["adj_per1"]
	end
	def compare
		@banner = banner()
	end
	def sfcities_compare
		render layout: getlayoutbyaction('sfcities_compare')
	end


	def bdqx_compare
		render layout: getlayoutbyaction('bdqx_compare')
	end


	def getlayoutbyaction(action_name)
		if action_name == 'sfcities_compare' || action_name == 'bdqx_compare'
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
			if c['city'] == '保定'
				hs = hs.merge(c)
				break
			end
		end
		# forecast data
		aqis = []
		pri_pol = []
		c = City.find_by_city_name_pinyin('baodingshi')
		ch = c.hourly_city_forecast_air_qualities.last(120).group_by_day(&:forecast_datetime)
		ch.each do |time,fds|
			t = Time.now
			if time > Time.local(t.year,t.month,t.day)
				#if time >= Time.local(2015,4,24)
				sum = []
				fds.each do |fd|
					sum << fd.AQI
				end
				aqis << [sum.min, sum.max]
				pri_pol << fds[0].main_pol
			end
		end

		lev_hs = {"you"=>"优", "yellow"=>"良", "qingdu"=>"轻度", "zhong"=>"中度","zhongdu"=>"重度", "yanzhong"=>"严重"}

		hs["lev"] = get_lev(hs["aqi"])
		hs["lev_han"] = lev_hs[hs["lev"]]

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
			response = HTTParty.get('http://www.weather.com.cn/adat/sk/101090201.html')	
			json_data = JSON.parse(response.body)
			hs = hs.merge(json_data['weatherinfo'])	
		rescue
			hs['real_time_weather'] = false	
		end

		hs["city_adj"] = 'ADJ_baoding/'
		hs["adj_per1"] = adj_percent('SO2_120', hs["city_adj"])
		hs["adj_per2"] = adj_percent('NOX_120', hs["city_adj"])
		hs["adj_per3"] = adj_percent('CO_120', hs['city_adj'])

		hs
	end 
end
