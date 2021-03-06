class Adjoint

    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend ActiveModel::Naming
    include NumRu

    attr_accessor :whatever
    validates :whatever, :presence => true

    def initialize(attributes = {})
        attributes.each do |name, value|
            send("#{name}=", value)
        end
    end

    def persisted?
        false
    end

    def self.grid2polygon(point_data)
        @factory ||= RGeo::Geographic.spherical_factory(:srid => 4326)
        #@factory = RGeo::Geographic.simple_mercator_factory

        polygon_list = []
        point_data.each do |p|
            coordinates = [ [p[:lon]-0.05, p[:lat]-0.05], [p[:lon]-0.05, p[:lat]+0.05], [p[:lon]+0.05, p[:lat]+0.05], [p[:lon]+0.05, p[:lat]-0.05],[p[:lon]-0.05, p[:lat]-0.05] ]
            ring = @factory.line_string(coordinates.map { |(x, y)| @factory.point x, y })
            polygon_list << @factory.polygon(ring)
        end
        polygon_list

    end

    def self.get_color(val)
        case val
        when -1E+9..0.1
            "#79E6F0"
        when 0.1..0.2
            "#C8DC33"
        when 0.2..0.4
            "#F0DC16"
        when 0.4..0.6
            "#FFBE16"
        when 0.6..0.8
            "#FF790C"
        when 0.8..1.0
            "#FF5B0C"
        when 1.0..2.0
            "#F02A02"
        when 2.0..4.0
            "#B40C02"
        when 4.0..8.0
            "#790C02"
        else
            "#330C02"
        end
    end

    def self.to_feature(datum, polygon, i, var)
        scale = {"SO2"=> 50, "BC"=>1E-7 }
        scale_v = {"SO2"=> 1, "BC"=>1E-9 }
        @entity_factory ||= RGeo::GeoJSON::EntityFactory.instance
        @entity_factory.feature(polygon, i, :height => (datum[:percent]*scale[var]).to_s, :color=> get_color(datum[:percent]*scale_v[var]),
                                :roofColor=> get_color(datum[:percent]*scale_v[var]))
        #@entity_factory.feature(polygon, i, :height => datum[:percent], :color=>"rgb(255,0,0)")
    end

    def self.read_adj_nc(var, period)
        path = "#{Rails.root.to_s}/tmp/data/"
        # TODO, Find latest date of adj file.
        #path = 'public/images/ftproot/Temp/BackupADJ/'
        fname = "CUACE_09km_adj_2016-06-25.nc"
        ncfile =path + '/' + fname;
        var_name = "#{var}_#{period}"

        file = NetCDF.open(ncfile)
        # Get longitude
        data = file.var(var_name).get
        return nil if data.nil?
        lat = file.var('lat').get
        lon = file.var('lon').get
        sp = data.shape
        #puts sp
        tmp = 1
        tmp = 1E+9 if var=="BC"
        point_data = []
        for i in 0..sp[0]-1
            for j in 0..sp[1]-1
                if data[i,j,0,0] > 0.1*tmp
                    point_data << {lon: lon[i], lat: lat[j], percent: data[i,j,0,0]}
                end
            end
        end
        point_data
    end

    LF_ADJ_CITY = %w(唐山 邢台 邯郸 保定 北京 天津 衡水 沧州 廊坊 石家庄 秦皇岛 承德 张家口)

    def self.to_geojson(var='SO2', period='120')
        geo_feature_collection = []
        # Read nc, get var, period Data
        point_data = read_adj_nc var,period
        return nil if point_data.nil?
        # Get each city percent.
        perc = city_percent(point_data, LF_ADJ_CITY)
        # Create grid lat lon -> polygon.
        polygon_list = grid2polygon(point_data)
        # To feature , return geo_json

        polygon_list.each_with_index do |p,i|
            geo_feature_collection << to_feature(point_data[i], p, i, var)
        end
        [RGeo::GeoJSON.encode(@entity_factory.feature_collection(geo_feature_collection)), perc]
    end

    def self.city_percent(point_data, city_list)
        perc = {}
        city_list.each { |c| perc[c] = 0.0 }
        sum = 0.0
        point_data.each do |p|
            region_name = Region.containing_latlon(p[:lat], p[:lon]).first.name
            sum = sum + p[:percent]
            city_list.each { |c| perc[c] = perc[c] + p[:percent] if region_name.index(c) }
        end
        qita = sum
        perc.each {|k,v| v>0 ? qita = qita - v : perc.delete(k) }
        perc["其他"] = qita if qita>0
        perc
    end

    def self.latest_file(path)
        return nil if !File.directory?(path) or Dir::entries(path).size == 0
        nt = Time.now
        i = 0
        begin
            strtime = (nt-60*60*24*i).strftime("%Y-%m-%d")
            ncfile = path + 'CUACE_09km_adj_'+strtime+'.nc'
            i = i + 1
        end until File::exists?(ncfile)
        ncfile
    end

    def self.ready_nc(var_name,cityname)
        #输入nc文件数据表名和城市名
        #返回nc文件中数据，数据格式二维数组，
        if Rails.env.development?
            ncp = '/Users/baoxi/Workspace/temp/'
        else
            ncp = '/mnt/share/Temp/BackupADJ_'+cityname+'/'
            # ncp = '/Users/baoxi/Workspace/temp/'
        end
        ncfile = latest_file(ncp)
        return nil if ncfile.nil?
        cdf = NetCDF.open(ncfile)
        ncd = cdf.var(var_name).get
        return nil if ncd.nil?
        {'data'=>ncd[0..-1,0..-1,0,0].to_a,'xmax'=>cdf.var('lon').get.max,'ymax'=>cdf.var('lat').get.max,'xmin'=>cdf.var('lon').get.min,'ymin'=>cdf.var('lat').get.min}
    end

    def self.read_grid(cityname)
        # 获取指定城市格点号
        # 输入城市名称
        # 返回该城市格点标号
        if Rails.env.development?
            gdf = '/Users/baoxi/Workspace/temp/'+cityname+'.txt' #格点文件
        else
            gdf = '/mnt/share/Temp/BackupADJ_'+cityname+'/grid_index/'+cityname+'.txt'
        end
        lines = File.open(gdf,'r')
        return nil if lines.nil?
        data = []
        lines.readlines.to_a[1..-1].each do |l|
            l = l.split(' ')
            data << [l[0].to_i,l[1].to_i,l[2].to_f,l[3].to_f]
        end
        data
    end

    def self.emission(var_name,cityname,percent,option)
        # 获取地图污染信息，减排aqi，时间
        # 输入污染类型，城市，百分比，以及其他参数option={'date'=>时间类型变量,'type'=>'电子行业','level'=>预警级别}
        # 输出污染数据，格点坐标，时间，aqi等
        rncd = ready_nc(var_name,cityname)
        ncd = rncd['data'].clone
        rncd.delete('data')
        grd = read_grid(cityname)
        return nil if ncd.nil? or grd.nil?
        sum = ncd.flatten.sum #污染物总值
        city = [] #该市污染物数值
        grds = [] #储存不含有格点下标的数
        grd.map do |l| #获取城市数据
            city << ncd[l[1]-1][l[0]-1]
            l << ncd[l[1]-1][l[0]-1]
            grds << {'xmin'=>l[2],'ymin'=>l[3],'xmax'=>l[2].to_f+0.1,'ymax'=>l[3].to_f+0.1}
        end
        sumc = city.sum
        frd = ForecastRealDatum.new.air_quality_forecast(cityname)
        aqi = frd[frd.keys.max]['AQI']
        return {'map'=>ncd,'grid'=>grds,'time'=>frd.keys.max,'aqi'=>aqi}.merge(rncd) if percent == 0 or sum == 0 or sumc == 0
        per_sum = sumc/sum.to_f #市内污染／总值
        aqi = (1 - per_sum*percent)*aqi
        sumg = 0 #各个格点数值和
        grdt = []
        grdp = []
        grds.clear
        grd.sort_by{|x| x[4]}.reverse.each do |i|
            sumg += i[4]
            grdt << i[4]
            grds << [i[0],i[1]]
            grdp << {'xmin'=>i[2],'ymin'=>i[3],'xmax'=>i[2].to_f+0.1,'ymax'=>i[3].to_f+0.1}
            break if sumg/sumc >= percent
        end
        ncd.map!{|l| l = Array.new(l.size){|e| e = 0}}
        grdt.each_index do |i|
            ncd[grds[i][1]-1][grds[i][0]-1] = grdt[i]
        end
        {'map'=>ncd,'grid'=>grdp,'time'=>frd.keys.max,'aqi'=>aqi}.merge(rncd)#map 网格数据；grid：企业坐标[{}];
    end

    def self.evaluate(cityname,stime,etime)
        #计算下降率
        #输入城市拼音，开始时间和结束时间
        #返回各项污染物实测值、预报值和下降率，格式：{2015-01-01:{'aqi'=>{'m'=>1,'f'=>1,'p'=>0.1}}},m:实测值，f：预报值，p：下降率
        mdata = TempSfcitiesDay.includes(:city).where('cities.city_name_pinyin'=>cityname,data_real_time:(stime.to_time.beginning_of_day..etime.to_time.end_of_day)).to_a.group_by_day(&:data_real_time)
        return nil if mdata.size == 0
        fdata = HourlyCityForecastAirQuality.new.forecast_24h(cityname,stime,etime)
        fdt = Hash.new
        fdata.each do |k,v|
            next if mdata[k].nil? || mdata[k].size == 0
            v.each do |m,n|
                tmp = Hash.new
                if mdata[k][0][m].to_f == 0
                    tmp['m'] = nil;tmp['f'] = n;tmp['p'] = nil;
                elsif mdata[k][0][m].to_f != 0
                    tmp['m'] = mdata[k][0][m].to_f
                    tmp['f'] = n
                    tmp['p'] = (tmp['f']-tmp['m'])/tmp['m']
                end
                v[m] = tmp
            end
            fdt[k] = v
        end
        fdt
    end

    def self.deal_nc_grid_enterprise(ncd,grid,elist,type,percent,industry,aqi)
        #处理nc，格点，企业数据,企业行业
        #返回网格数据，企业数据,城市所占aqi百分比
        elist = elist.as_json
        ensum = 0.0
        pcity = 0.0
        psum = ncd.flatten.sum
        gens = Hash.new
        grid.each_index do |i|
            z = grid[i]
            x = z[1] - 1
            y = z[0] - 1
            pcity += ncd[x][y]
            grid[i] << ncd[x][y]
            elist.each do |n| # 格点中的企业
                if (z[2]..z[2]+0.1) === n['longitude'] and (z[3]..z[3]+0.1) === n['latitude']
                    n['x'] = x
                    n['y'] = y
                    gens[z[0].to_s+z[1].to_s] = Array.new if gens[z[0].to_s+z[1].to_s].nil?
                    gens[z[0].to_s+z[1].to_s] << n 
                end
            end
        end
        return false if psum == 0 or pcity == 0 or gens.size == 0
        city_pre = pcity/psum*percent
        gens.map do |k,v|
            tsum = v.inject(0.0){|r,x| r += x[type]}
            tsum = 0.0000001 if tsum == 0
            v.map{|x| x['percent'] = x[type]/tsum} #格点中的企业污染物占比
        end
        grid.each do |l|
            temp = l[4]/psum
            next if gens[l[0].to_s+l[1].to_s].nil?
            gens[l[0].to_s+l[1].to_s].each do |e|
                # byebug if e['percent'] > 0.01
                e['percent'] = e['percent'].to_f*temp #企业贡献率
                # puts e['percent'].to_s+' '+temp.to_s
            end
        end
        gens = gens.values.flatten.delete_if{|x| x['percent'].to_f < 0.00001}
        return {'map_data'=>ncd,'reduce_aqi'=>aqi.round(0),'en_list'=>gens} if percent == 0
        ens = Array.new
        if industry
            gens = gens.group_by{|x| x['en_category'] == industry}
            tsum = 0.0
            gens[true].sort{|x,y| y['percent']<=>x['percent']}.each{|x| ens << x;tsum += x['percent'];break if tsum >= city_pre} unless gens[true].nil?
            gens[false].sort{|x,y| y['percent']<=>x['percent']}.each{|x| ens << x;tsum += x['percent'];break if tsum >= city_pre} if !gens[false].nil? and tsum <= city_pre
        else
            tsum = 0.0
            gens.sort{|x,y| y['percent']<=>x['percent']}.each do |l|
                next if l['percent'] < 0.000001
                ens << l
                tsum += l['percent']
                break if tsum >= city_pre
            end
        end
        ncdn = ncd.clone
        ncdn.map!{|x| x = Array.new(x.size){|e| e = 0}}
        ens.each do |e|
            ncdn[e['x']][e['y']] = ncd[e['x']][e['y']]
        end
        percent = 0 if percent = 1
        {'map_data'=>ncdn,'reduce_aqi'=>(pcity/psum*(1-percent)*aqi).round(0),'en_list'=>ens}
    end
    def self.emission_v1(citypy='langfangshi',var='nox',percent=0,*arg)
        # 获取地图污染信息，减排aqi
        # 输入污染类型:nox，城市，百分比，以及其他参数(arg[0]:行业)
        # 输出污染数据，格点坐标，时间，aqi,企业信息等
        rncd,grd,ncd,frd,gset = nil
        th1 = Thread.new{ rncd = ready_nc(var.upcase+'_120',citypy)}
        th2 = Thread.new{ grd = read_grid(citypy)}
        th3 = Thread.new{ frd = ForecastRealDatum.new.air_quality_forecast(citypy)}
        # th4 = Thread.new{ gset = City.find_by_city_name_pinyin(citypy).enterprises.where(var+'_discharge'+'>-1').as_json}
        gset = City.find_by_city_name_pinyin(citypy).enterprises.where(var+'_discharge'+'>-1').as_json

        th1.join
        th2.join
        th3.join
        # th4.join #获取需要的数据
        return nil if rncd.nil? or grd.nil? #没有数据返回nil
        aqi = frd[frd.keys.max]['AQI']
        result = deal_nc_grid_enterprise(rncd['data'].clone,grd,gset,var+'_discharge',percent,arg[0],aqi)
        rncd.delete('data')
        result['map_data'] = {var => result['map_data']}
        result['map_data'].merge!(rncd)
        result['time'] = Hash.new
        result['time']['stime'] = frd.keys.min.to_time.strftime('%m月%d日')
        result['time']['etime'] = frd.keys.max.to_time.strftime('%m月%d日')
        enlist = result['en_list'].clone
        if enlist.size == 0
            result['en_barchart'] = {'county_name'=>[],'en_count'=>[]}
            result['en_pie']={'en_category'=>[],'piedata'=>[]}
        else 
            result['en_barchart'] = {'county_name'=>enlist.group_by{|x| x['county_id']}.keys.map{|e| County.find(e).name},'en_count'=>enlist.group_by{|x| x['county_id']}.map{|k,v| v.size}}
            result['en_pie']={'en_category'=>enlist.group_by{|x| x['en_category']}.keys,'piedata'=>enlist.group_by{|x| x['en_category']}.map{|k,v| {'value'=>v.size,'name'=>k}}}
        end
        index = 0
        result['en_list'] = result['en_list'].map{|x| {'id'=>x['id'],'number'=>index+=1,'en_name'=>x['en_name'],'contribution'=>(x['percent']*100).round(5)}}
        result
    end

    def self.emission_by_enterprise(citypy='langfangshi',var='nox',enterprises)
        #通过企业贡献率获取减排率
        #输入城市拼音、污染物类型、企业信息、aqi
        #输出网格数据、减排aqi
        rncd,grd,frd = nil
        th1 = Thread.new{ rncd = ready_nc(var.upcase+'_120',citypy)}
        th2 = Thread.new{ grd = read_grid(citypy)}
        th3 = Thread.new{ frd = ForecastRealDatum.new.air_quality_forecast(citypy)}
        th1.join
        th2.join
        th3.join
        return nil if rncd.nil? or grd.nil? #没有数据返回nil
        ncd = rncd['data'].clone
        rncd.delete('data')
        psum = ncd.flatten.sum
        contribution = enterprises.inject(0.0){|r,x| r+=x['contribution'].to_f/100} 
        aqi = frd[frd.keys.max]['AQI']*(1-contribution)
        pcity = 0.0
        llcity = Array.new
        enlist = Enterprise.where(id:enterprises.map{|x| x['id']})
        grd.each do |l|
            x = l[1]-1
            y = l[0]-1
            pcity += ncd[x][y]
            templist = Array.new
            enlist.each do |e|
                if (l[2]..(l[2]+0.1)) === e.longitude and (l[3]..(l[3]+0.1)) === e.latitude
                    llcity << l 
                else
                    templist << e
                end
            end
            enlist = templist
        end
        ncdt = ncd.map{|x| x = Array.new(x.size){|e| e = 0}}
        llcity.each do |l|
            ncdt[l[1]-1][l[0]-1] = ncd[l[1]-1][l[0]-1]
        end
        (pcity.nil? or pcity == 0) ? percent = 0 : percent = contribution*psum/pcity
        {"map_data"=>{var=>ncdt}.merge(rncd),'reduce_aqi'=>aqi.round(0),'percent'=>percent*100}
    end
    def self.test
        MyWorker.perform_async(9)
        MyWorker.perform_async(4)
    end
end
