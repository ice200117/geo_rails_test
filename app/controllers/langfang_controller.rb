class LangfangController < ApplicationController
	# class LangfangController < Casein::CaseinController

	include NumRu

	#获取预测数据
	def get_forecast
		@weather = Hash.new
		#Custom::Redis.del('langfang_weather')
		if Custom::Redis.get('langfang_weather').nil?
			city_name_encode = ERB::Util.url_encode("廊坊")
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

      fore_range = ForecastDailyDatum.get_three_daily_range
      temp = ForecastRealDatum.new.air_quality_forecast('langfangshi')
      pdate = temp.first[0].to_date
      if fore_range[0].length == 0# or pdate > fore_range[1]
        city_id =  18 #City.find_by_city_name_pinyin('langfangshi').id
        temp.each do |k,v|
          d = {}
          d["city_id"] = city_id
          d["publish_date"] = pdate
          d["forecast_date"] = k.to_date
          d["max_forecast"] = v["max"]
          d["min_forecast"] = v["min"]
          d["main_pollutant"] = v["main_pol"]
          f = ForecastDailyDatum.find_or_create_by(city_id: city_id, publish_date: pdate, forecast_date: k.to_date)
          f.max_forecast = v["max"]
          f.min_forecast = v["min"]
          f.main_pollutant = v["main_pol"]
          f.save

          d["fore_lev"] = get_lev(v["min"])
          d["fore_lev1"] = get_lev(v["max"])
          d["level"] = v["level"]
          d["level1"] = v["level1"]


          key = k.to_time.strftime("%Y%m%d")
          if @weather[key] != nil# and k.to_date >= Date.today
            @weather[key]=@weather[key].merge(d)
          end
        end
        Custom::Redis.del('langfang_weather')
      else
        fore_range[0].each do |k,v|
          v["fore_lev"] = get_lev(v["min_forecast"])
          v["fore_lev1"] = get_lev(v["max_forecast"])
          key = k.to_time.strftime("%Y%m%d")
          if @weather[key] != nil
            @weather[key]=@weather[key].merge(v)
          end
        end
      end
			Custom::Redis.set('langfang_weather',@weather,3600)
		else
			@weather=Custom::Redis.get('langfang_weather')
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

	def forecast
		@banner = banner()
		@day_fdata = @banner["day_fdata"]
		#@city_adj = @banner["city_adj"]
		#@adj_per1 = @banner["adj_per1"]
		@imgTime = Time.now.strftime("%Y%m%d")
		@forecast_data = get_forecast()
    get_forecast_pics
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
			@str_date = t.strftime("%Y%m%d")
			name = "CUACE_09km_#{type}_#{str_time}.png"
			pic_name = "#{url}#{@str_date}/Hourly/#{name}"
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
			pic_name = "#{url}#{@str_date}/Hourly/#{name}"
			pic["time"] = t.strftime("%m月%d日%H时")
			pic["pic_url"] = pic_name
			pics << pic
			t = t + 1.hour
		end

		pics
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
		if $redis['langfang_hour_forecast'].nil?
			c = City.find_by_city_name_pinyin('langfangshi')
			ch = c.forecast_real_data.last(120).group_by_day(&:forecast_datetime)
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

		return hs
	end
end
