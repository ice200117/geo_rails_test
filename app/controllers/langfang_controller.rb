class LangfangController < ApplicationController
# class LangfangController < Casein::CaseinController

	include NumRu
	protect_from_forgery :except => [:get_forecast_baoding, :get_city_point]

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

	def get_history_data
		model = params[:model]
		time = params[:time].to_time
		data = change_data_type(get_db_data(model.constantize,time),0)
		render :json=>data
	end

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


		@rank={'hour'=>get_rank(@sfcitiesrankbyhour)}
		@rank['day']=get_rank(@sfcitiesrankbyday[:cities])
		@rank['month']=get_rank(@sfcitiesrankbymonth[:cities])
		@rank['year']=get_rank(@sfcitiesrankbyyear[:cities])

		@banner = banner()

		@forecast_data = get_forecast()

		# adj data
		@city_adj = 'ADJ_baoding/'

	end
	def get_rank(data)
		tmp=data.sort_by{|a| a['zonghezhishu']}
		(0...tmp.length).each do |n|
			if tmp[n]['city_id'] == 11
				return tmp.length-n-1
			end
		end
		return '--'
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
		if $redis[model.name].nil?
			sql_str=Array.new
			sql_str<<"data_real_time >= ? AND data_real_time <= ?"
			sql_str<<stime
			sql_str<<etime
			data = model.where(sql_str)
			tmpd = /\w*Hour/.match(model.name) ? 3600 : 3600*24
			Custom::Redis.set(model.name,data,tmpd)
			data
		else
			Custom::Redis.get(model.name)
		end
	end

	#修改小数点位数
	def change_data_type(data,flag)			
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
		@weather = Hash.new
		if Custom::Redis.get('langfang_weaterh').nil?
			city_name_encode = ERB::Util.url_encode("秦皇岛")
			options = Hash.new
			headers={'apikey' => 'f8484c1661a905c5ca470b0d90af8d9f'}
			options[:headers] = headers
			url = "http://apis.baidu.com/showapi_open_bus/weather_showapi/address?area=#{city_name_encode}&needMoreDay=1"
			response = HTTParty.get(url,options)
			json = JSON.parse(response.body)
			# puts 0 if json['showapi_res_error'] == 0
			json['showapi_res_body'].each do |k,v|
				if k[-1].to_i > 0 
					tq = get_tq(v)
					@weather[tq['day']] = tq
				end
			end
			temp = HourlyCityForecastAirQuality.new.air_quality_forecast('qinhuangdaoshi')
			temp.each do |k,v|
				v["fore_lev"] = get_lev(v["AQI"])
				key = k.to_time.strftime("%Y%m%d")
				if @weather[key] != nil
					@weather[key]=@weather[key].merge(v)
				end
			end
			Custom::Redis.set('langfang_weaterh',@weather,3600*24)
		else
			@weather=Custom::Redis.get('langfang_weaterh')
		end
		@ret=@weather
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
		path = 'public/images/ftproot/Temp/Backup'+city+'/'
		#path = '/mnt/share/Temp/Backup'+city+'/'
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

	def forecast
		@banner = banner()
		@day_fdata = @banner["day_fdata"]
		#@post='130300'
		#@city_adj = @banner["city_adj"]
		#@adj_per1 = @banner["adj_per1"]
		@forecast_data = get_forecast()
		@imgTime = Time.now.strftime("%Y%m%d")
		@forecast_data = get_forecast()
	end
  
  def lf_forecast_pics
    type = params["type"] if params["type"]
    @pics = get_forecast_pics(type)
		respond_to do |format|
			format.html { render json: @pics}
			format.js {  }
			format.json { render json: @pics}
		end
  end

  def get_forecast_pics(type="AQI")
    pics =[]
    stime = Time.now
    etime = (stime+3.days).beginning_of_day
    url = 'http://60.10.135.153:3000/images/ftproot/Products/Web/Forecast/CUACE/'
    t = stime
    str_time = t.strftime("%Y-%m-%d_%H")
    while(t+5.days > stime) do
      str_date = t.strftime("%Y%m%d")
      name = "CUACE_09km_#{type}_#{str_time}.png"
      pic_name = "#{url}#{str_date}/Hourly/#{name}"
      begin
        response = HTTParty.get(pic_name)	
        break if response.code==200
      rescue
      end
      t = t - 1.day
    end


    t = stime
    while(t<etime) do 
      pic ={}
      str_time = t.strftime("%Y-%m-%d_%H")
      name = "CUACE_09km_#{type}_#{str_time}.png"
      pic_name = "#{url}#{str_date}/Hourly/#{name}"
      pic["time"] = t.strftime("%m月%d日%H时")
      pic["pic_url"] = pic_name
      pics << pic
      t = t + 1.hour
    end
    pics
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
			if c['city'] == '廊坊'
				hs = hs.merge(c)
				break
			end
		end
		# forecast data
		aqis = []
		pri_pol = []
		ch=nil
		#if $redis['langfang_hour_forecast'].nil?
			c = City.find_by_city_name_pinyin('langfangshi')
			ch = c.hourly_city_forecast_air_qualities.order(:publish_datetime).last(72).group_by_day(&:forecast_datetime)
			Custom::Redis.set('langfang_hour_forecast',ch,3600*24)
		else
			ch = Custom::Redis.get('langfang_hour_forecast')
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
			response = HTTParty.get('http://www.weather.com.cn/adat/sk/101090601.html')	
			json_data = JSON.parse(response.body)
			hs = hs.merge(json_data['weatherinfo'])	
		rescue
			hs['real_time_weather'] = false	
		end

		#hs["city_adj"] = 'ADJ_qinhuangdao/'
		#force = 'qhd'
		#hs["adj_per1"] = adj_percent('SO2_120', hs["city_adj"], force)
#		hs["adj_per2"] = adj_percent('NOX_120', hs["city_adj"], force)
#		hs["adj_per3"] = adj_percent('CO_120', hs['city_adj'], force)

		return hs
	end 

end