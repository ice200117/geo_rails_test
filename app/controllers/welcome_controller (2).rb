class WelcomeController < ApplicationController
	include NumRu

	def map
		respond_to do |format|
			format.js   {}
			format.html   {}
			format.json {
				achf = Hash.new
				cs = City.all
				cs.each do |c|
					ch = c.hourly_city_forecast_air_qualities.last(120)[0]
					achf[c.city_name] = ch.AQI  if ch
				end
				render json: achf
			}
		end
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
		params[:c] ? (id =  params[:c][:city_id]) : (id = City.find_by city_name_pinyin: 'langfangshi')
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
		#@chart = [{name: c.city_name, data: hs.group_by_hour(:forecast_datetime).average("AQI")}]
		@chart = [{name: c.city_name, data: hs.map { |h| [ h.forecast_datetime.strftime("%H\n %d%b"),  h.AQI]} }]
		#@chart = c.hourly_city_forecast_air_qualities.group_by_hour(:forecast_datetime).average("AQI")
		respond_to do |format|
			format.html { }
			format.js   { }
			format.json {
				render json: @chart
			}
		end
	end

	def get_history_data
		model = params[:model]
		time = params[:time]
		change_data_type(get_db_data(model.constantiz,time))
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
		hebeidatabyday[:cities].delete_if{|item| (item['city']=='北京')||(item['city']=='天津')}
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
		
		# forecast data
		@forecast_data = get_forecast()
		
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

		# adj data
		@city_adj = 'ADJ_baoding'

		@factor='SO2'
		@adj_per1 = adj_percent('SO2_120', @city_adj)
		@adj_per2 = adj_percent('NOX_120', @city_adj)
		@adj_per3 = adj_percent('CO_120', @city_adj)

		lev_hs = {"you"=>"优", "yellow"=>"良", "qingdu"=>"轻度", "zhong"=>"中度","zhongdu"=>"重度", "yanzhong"=>"严重"}

		@lev = get_lev(@aqi)
		@lev_han = lev_hs[@lev]

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

		@day_fdata = []
		lev_arr.each_with_index do |lev,i|
			@day_fdata << {w:td[i], start:lev[:start], end:lev[:end], start_han:lev_han_arr[i][:start], end_han:lev_han_arr[i][:end],pol:pri_pol[i]}
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
	def get_db_data(model_name,time)
		stime = time 
		etime = time 
		if /\w*Hour/.match(model_name.name)
			stime = stime.beginning_of_hour
			etime = etime.end_of_hour
		else
			stime = stime.beginning_of_day
			etime = etime.end_of_day
		end
		sql_str=Array.new
		sql_str<<"data_real_time >= ? AND data_real_time <= ?"
		sql_str<<stime
		sql_str<<etime
		data = model_name.where(sql_str)
		#return data.uniq if !data[0].nil?  #不为空，去掉重复项并返回
		data[0].nil? ? [] : data.uniq
		#end
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
		response = HTTParty.get('http://www.izhenqi.cn/api/getforecast_weather.php')
		json_data = JSON.parse(response)
		temp = HourlyCityForecastAirQuality.new.air_quality_forecast('baodingshi')
		temp.each do |k,v|
			index=k.yday - Time.now.yday
			v["AQI"]
			json_data["weather_forecast"][index].merge(v)
		end
		json_data["weather_forecast"]
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
			startdate=Time.local(params[:starttime][0,4].to_i,params[:starttime][5,2].to_i,params[:starttime][8,2].to_i,10)
			enddate=Time.local(params[:endtime][0,4].to_i,params[:endtime][5,2].to_i,params[:endtime][8,2].to_i,21)
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

	def city_compare_chart
		city1=City.find_by city_name: params[:city1]
		city2=City.find_by city_name: params[:city2] 
		city3=City.find_by city_name: params[:city3]
		cityarray=Array[city1,city2,city3]


		startdate=Time.local(params[:starttime][0,4].to_i,params[:starttime][5,2].to_i,params[:starttime][8,2].to_i)
		enddate=Time.local(params[:endtime][0,4].to_i,params[:endtime][5,2].to_i,params[:endtime][8,2].to_i,23)
		if  params[:starttime]==params[:endtime] 
			startdate=Time.local(params[:starttime][0,4].to_i,params[:starttime][5,2].to_i,params[:starttime][8,2].to_i,10)
			enddate=Time.local(params[:endtime][0,4].to_i,params[:endtime][5,2].to_i,params[:endtime][8,2].to_i,21)
			querydata=TempSfcitiesHour.where("data_real_time>=? AND data_real_time<=? AND city_id: [?,?,?]",startdate,enddate,city1.id,city2.id,city3.id)
		elsif params[:exact]=='eh'
			querydata=TempSfcitiesHour.where("data_real_time>=? AND data_real_time<=? AND city_id: [?,?,?]",startdate,enddate,city1.id,city2.id,city3.id) 
		else
			querydata=TempSfcitiesDay.where("data_real_time>=? AND data_real_time<=? AND city_id: [?,?,?]",startdate,enddate,city1.id,city2.id,city3.id)
		end  
		@citycompare={categories: querydata.map{ |data| params[:exact]=='eh' ? data.data_real_time.strftime("%m-%d %H") : data.data_real_time.strftime("%Y-%m-%d")}, series: cityarray.map{ |cityobj| {name: cityobj.city_name,data: querydata.map{ |data| data[params[:type]] if data.city_id==cityobj.id}}}}

		respond_to do |format|
			format.html { }
			format.js   { }
			format.json {
				render json: @citycompare
			}
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
			puts var_name
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
	end

	def forecast
		@banner = banner()
	end
	def compare
		@banner = banner()
	end

	def banner
		hs = Hash.new
		# monitor data
		md = hb_real
		hs[:rt]= md[:time]
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

		hs[:lev] = get_lev(hs[:aqi])
		hs[:lev_han] = lev_hs[hs[:lev]]

		#实时天气预报
		begin
			response = HTTParty.get('http://www.weather.com.cn/adat/sk/101090201.html')	
			json_data = JSON.parse(response.body)
			hs = hs.merge(json_data['weatherinfo'])	
		rescue
			hs[:real_time_weather] = false	
		end
		@hs = hs
	end 
end