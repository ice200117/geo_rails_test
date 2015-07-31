class WelcomeController < ApplicationController
  include NumRu


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

  def pinggu

	#d = DateTime.now
	#d -= 1
	#dd=d-1
  @lfdatabyhour=get_rank_json('rankdata','LANGFANGRANK','HOUR','')
  @lfdatabyday=get_rank_json('rankdata','LANGFANGRANK','DAY','')
  @chinadata=get_rank_json('rankdata','CHINARANK','DAY','')
  @hebeidatabyhour=get_rank_json('rankdata','HEBEIRANK','HOUR','');
  @hebeidatabyday=get_rank_json('rankdata','HEBEIRANK','DAY','');
  @sfcitiesrankbyday=get_rank_json('zq','CHINARANK','DAY','')
	@sfcitiesrankbymonth=get_rank_json('sfcitiesrankbymonthoryear','CHINARANK','MONTH','')
	@sfcitiesrankbyyear=get_rank_json('sfcitiesrankbymonthoryear','CHINARANK','YEAR','')
	#@jjjzonghezhishubyday=get_rank_json('lfdatabyhistory','JINGJINJIDATA','DAY',d.strftime('%Y-%m-%d'))
	
	
	#廊坊各县市区污染物浓度(同期变化率)（日报）查询
	#@lfgqxdatabyday=get_rank_json('lfgqxbyday','','',dd.strftime('%Y-%m-%d'))
	#lfgqxbyday=TempLfDay.where("data_real_time>=? AND data_real_time<=?",Time.now.beginning_of_day,Time.now.end_of_day).order('zonghezhishu asc')
	lfgqxbyday=set_nil_value(TempLfDay.last(11)).sort_by{|templfday| templfday.zonghezhishu}#如果有些记录的综合指数列为nil则会拿nil与float进行比较排序，sort_by会报错
	cityname=Array.new
	i=1
	lfgqxbyday.each do |c|
		if i==1 
			@lf_day_data_real_time=c.data_real_time
			end
		ccc=City.find(c.city_id) if c.city_id!=nil
		cityname[i]=ccc.city_name if c.city_id!=nil
		i+=1
		#c[:cityname] =ccc.city_name if c.city_id!=nil
	end
	@lfgqxdatabyday=lfgqxbyday
	@citynamehs=cityname
	
	
	#廊坊各县市区污染物浓度(同期变化率)（月报）查询
	lfgqxbymonth=set_nil_value(TempLfMonth.last(11)).sort_by{|templfmonth| templfmonth.zonghezhishu}#如果有些记录的综合指数列为nil则会拿nil与float进行比较排序，sort_by会报错
	cityname1=Array.new
	i=1
	lfgqxbymonth.each do |c|
		if i==1 
			@lf_month_data_real_time=c.data_real_time
			end
		ccc=City.find(c.city_id) if c.city_id!=nil
		cityname1[i]=ccc.city_name if c.city_id!=nil
		i+=1
		#c[:cityname] =ccc.city_name if c.city_id!=nil
	end
	@lfgqxdatabymonth=lfgqxbymonth
	@citynamehs1=cityname1
	
	
	#廊坊各县市区污染物浓度(同期变化率)（年报）查询
	lfgqxbyyear=set_nil_value(TempLfYear.last(11)).sort_by{|templfyear| templfyear.zonghezhishu}#如果有些记录的综合指数列为nil则会拿nil与float进行比较排序，sort_by会报错
	cityname2=Array.new
	i=1
	lfgqxbyyear.each do |c|
		if i==1 
			@lf_year_data_real_time=c.data_real_time
			end
		ccc=City.find(c.city_id) if c.city_id!=nil
		cityname2[i]=ccc.city_name if c.city_id!=nil
		i+=1
		#c[:cityname] =ccc.city_name if c.city_id!=nil
	end
	@lfgqxdatabyyear=lfgqxbyyear
	@citynamehs2=cityname2
	
	
	
	
	
	#京津冀城市污染物浓度(同期变化率)（日报）查询
	jjjcsbyday=set_nil_value(TempJjjDay.last(13)).sort_by{|tempjjjday| tempjjjday.zonghezhishu}#如果有些记录的综合指数列为nil则会拿nil与float进行比较排序，sort_by会报错
	cityname3=Array.new
	i=1
	jjjcsbyday.each do |c|
		if i==1 
			@jjj_day_data_real_time=c.data_real_time
			end
		ccc=City.find(c.city_id) if c.city_id!=nil
		cityname3[i]=ccc.city_name if c.city_id!=nil
		i+=1
		#c[:cityname] =ccc.city_name if c.city_id!=nil
	end
	@jjjcsdatabyday=jjjcsbyday
	@citynamehs3=cityname3
	
	
	#京津冀城市污染物浓度(同期变化率)（月报）查询
	jjjcsbymonth=set_nil_value(TempJjjMonth.last(13)).sort_by{|tempjjjmonth| tempjjjmonth.zonghezhishu}#如果有些记录的综合指数列为nil则会拿nil与float进行比较排序，sort_by会报错
	cityname4=Array.new
	i=1
	jjjcsbymonth.each do |c|
		if i==1 
			@jjj_month_data_real_time=c.data_real_time
			end
		ccc=City.find(c.city_id) if c.city_id!=nil
		cityname4[i]=ccc.city_name if c.city_id!=nil
		i+=1
		#c[:cityname] =ccc.city_name if c.city_id!=nil
	end
	@jjjcsdatabymonth=jjjcsbymonth
	@citynamehs4=cityname4
	
	
	#京津冀城市污染物浓度(同期变化率)（年报）查询
	jjjcsbyyear=set_nil_value(TempJjjYear.last(13)).sort_by{|tempjjjyear| tempjjjyear.zonghezhishu}#如果有些记录的综合指数列为nil则会拿nil与float进行比较排序，sort_by会报错
	cityname5=Array.new
	i=1
	jjjcsbyyear.each do |c|
		if i==1 
			@jjj_year_data_real_time=c.data_real_time
			end
		ccc=City.find(c.city_id) if c.city_id!=nil
		cityname5[i]=ccc.city_name if c.city_id!=nil
		i+=1
		#c[:cityname] =ccc.city_name if c.city_id!=nil
	end
	@jjjcsdatabyyear=jjjcsbyyear
	@citynamehs5=cityname5
	
	
	
	
	
    @post = params[:city_post] if params[:city_post]
    @post = '130600' if @post==nil || @post==''
    @city_name = ChinaCity.get(@post)
    @province_name = ChinaCity.get(@post[0,2]+'0000')

    case @province_name
    when '北京市'
      @city_name = @province_name
    when '上海市'
      @city_name = @province_name
    when '天津市'
      @city_name = @province_name
    when '重庆市'
      @city_name = @province_name
    end

    # monitor data
    md = hb_real
    @rt = md[:time]
    md[:cities].each do |c|
      if @city_name.include? c['city']
        p @city_name, c['city']
        @aqi = c['aqi']
        @pm2_5 = c['pm2_5']
        @pm10 = c['pm10']
        @so2 = c['so2']
        @no2 = c['no2']
        @o3 = c['o3']
        @co = c['co']
      end
    end




    # forecast data
    aqis = []
    pri_pol = []
    c = City.find_by_post_number(@post)
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
    p aqis

    # adj data
    case @post
    when '130600'
      @city_adj = 'ADJ_baoding/'
    else
      @city_adj = 'ADJ/'
    end

    @factor='SO2'
    @adj_per1 = adj_percent('SO2_120', @city_adj)
    @adj_per2 = adj_percent('NOX_120', @city_adj)
    @adj_per3 = adj_percent('CO_120', @city_adj)
    #@adj_per = {'保定' =>  54.34, '北京' => 12.25}
    #@factor = 'SO2'
    p @adj_per


    # test data
    @county_data = [{title:'安次区',aqi:191,yesterday_aqi:179,r_rank:1,yesterday_r_rank:2}, 
                    {title:'广阳区', aqi:182,yesterday_aqi:186,r_rank:2,yesterday_r_rank:1}, 
                    {title:'廊坊开发区', aqi:140,yesterday_aqi:177,r_rank:3,yesterday_r_rank:3}, 
                    {title:'固安县', aqi:134,yesterday_aqi:151,r_rank:4,yesterday_r_rank:6}, 
                    {title:'永清县', aqi:112,yesterday_aqi:136,r_rank:5,yesterday_r_rank:7}, 
                    {title:'香河县', aqi:110,yesterday_aqi:168,r_rank:6,yesterday_r_rank:4}, 
                    {title:'大城县', aqi:101,yesterday_aqi:97,r_rank:7,yesterday_r_rank:10}, 
                    {title:'文安县', aqi:97,yesterday_aqi:119,r_rank:8,yesterday_r_rank:9}, 
                    {title:'大厂', aqi:96,yesterday_aqi:132,r_rank:9,yesterday_r_rank:8}, 
                    {title:'霸州市', aqi:92,yesterday_aqi:92,r_rank:10,yesterday_r_rank:11}, 
                    {title:'三河市', aqi:91,yesterday_aqi:160,r_rank:11,yesterday_r_rank:5}]

    lev_hs = {"you"=>"优", "yellow"=>"良", "qingdu"=>"轻度", "zhong"=>"中度","zhongdu"=>"重度", "yanzhong"=>"严重"}

    #ban lev
    #@aqi = 120
    @lev = get_lev(@aqi)
    @lev_han = lev_hs[@lev]

    # table lev
    #aqis = [[20,40],[30,80],[80,100],[40,120],[110,400]]
    #pri_pol = ['pm2.5','pm2.5','pm2.5','pm10','O3']
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

  def jjj_history_data(datestr)
    option = {secret:'JINGJINJIDATA',type:'DAY',date:datestr,key:Digest::MD5.hexdigest('JINGJINJIDATA'+'DAY'+datestr) }
    response = HTTParty.post('http://www.izhenqi.cn/api/getdata_history.php', :body => option)
    JSON.parse(response.body)
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

  def get_rank_json(webUrl,secretstr,typestr,datestr)
    hs = Hash.new
    begin
      if webUrl == 'zq'
        response = HTTParty.get('http://www.izhenqi.cn/api/getdata_cityrank.php?secret='+secretstr+'&type='+typestr+'&key='+Digest::MD5.hexdigest(secretstr+typestr))		
      elsif webUrl == 'lfgqxbyday'
        response = HTTParty.get('http://115.28.227.231:8082/api/data/day-qxday?date='+datestr)
      elsif webUrl == 'lfdatabyhistory'
        option = {secret:secretstr,type:typestr,date:datestr,key:Digest::MD5.hexdigest(secretstr+typestr+datestr) }
        response = HTTParty.post('http://www.izhenqi.cn/api/getdata_history.php', :body => option)
      elsif webUrl == 'rankdata'
        option = {secret:secretstr,type:typestr,key:Digest::MD5.hexdigest(secretstr+typestr) }
        response = HTTParty.post('http://www.izhenqi.cn/api/getrank.php', :body => option)
      elsif webUrl == 'lfdatabymonth'
        option = {secret:secretstr,type:typestr,date:datestr,key:Digest::MD5.hexdigest(secretstr+typestr+datestr) }
        response = HTTParty.post('http://www.izhenqi.cn/api/getrank_month.php', :body => option)
      elsif webUrl == 'sfcitiesrankbymonthoryear'
        option = {secret:secretstr,type:typestr,key:Digest::MD5.hexdigest(secretstr+typestr) }
        response = HTTParty.post('http://www.izhenqi.cn/api/getrank_forecast.php', :body => option)
      end
      #json_data=JSON.parse(response.body)
      response.body.sub(/{.*}/) { |match| 
        json_data=JSON.parse(match) 
        puts  json_data['time']
        hs[:time] =json_data['time']
        hs[:cities] = json_data['rows']
      }
    rescue
      puts 'Can not get data from izhenqi, please check network!'
    end 
    hs
  end

  def get_data_to_pinggu
    @lfdatabyhour=get_rank_json('lfdata','LANGFANGRANK','HOUR','')
  end

  def set_nil_value(data)
    data.each do |c|
      if c.zonghezhishu==nil 
          c.zonghezhishu=10000
        end
      if c.zongheindex_change_rate==nil
          c.zongheindex_change_rate=10000
        end
    end
    data
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
    "public/adj/zhangjiakou.txt" ]
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
    "张家口" ]
  def adj_percent(type="", city='ADJ_baoding')
    nt = Time.now
    i = 0
    path = 'public/images/ftproot/Temp/Backup'+city+'/'
    begin
      #puts i
      strtime = (nt-60*60*24*i).strftime("%Y-%m-%d")
      ncfile = path + 'CUACE_09km_adj_'+strtime+'.nc'
      #ncfile='public\images\CUACE_09km_adj_2015-06-27.nc'
      i = i + 1
      return {} if i>30
    end until File::exists?(ncfile)

    #ncfile = 'public/adj/CUACE_09km_adj_2015-06-08.nc'

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

end

