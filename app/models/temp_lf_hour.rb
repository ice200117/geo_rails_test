class TempLfHour < ActiveRecord::Base
	validates :city_id, uniqueness: { scope: :data_real_time,
    message: "数据重复！" }

    def atmospheric_volume_superscalar
        #大气容量超标计算
        #输出
        level2 = {'SO2'=>60,'NO2'=>40,'CO'=>4,'O3'=>160,'pm25'=>35,'pm10'=>70}
        region = {
            '安次区'=>[595_000_000,1,'建成区'],'广阳区'=>[313_000_000,1.5,'建成区'],'开发区'=>[69_500_000,8,'建成区'],
            '香河县'=>[458_000_000,1,'北三县'],'三河市'=>[643_000_000,0.8,'北三县'],'大厂回族自治县'=>[176_000_000,3,'北三县'],
            '固安县'=>[697_000_000,0.8,'南五县'],'永清县'=>[774_000_000,0.7,'南五县'],
            '大城县'=>[910_000_000,0.5,'南五县'],'文安县'=>[980_000_000,0.5,'南五县'],
            '霸州市'=>[784_000_000,0.7,'南五县']
        }
        mix = [37,35,30,25,20]
        ids = City.where(city_name:region.keys).ids
        stime = Time.now.beginning_of_hour - 3600
        etime = Time.now.end_of_hour - 3600
        data = self.class.where(city_id:ids,data_real_time:(stime..etime))
        return nil if data.size == 0
        result = Array.new
        result << level2.keys
        data.group_by{|x| x.city_id}.each do |k,v|
            name = City.find(k).city_name #区县名称
            filter = {'SO2'=>0,'NO2'=>0,'CO'=>0,'O3'=>0,'pm25'=>0,'pm10'=>0}
            tmp = Array.new
            tmp << region[name][2]
            tmp << name
            b = mix_height(v[0].AQI)
            filter.each do |m,n|
                n += v[0].send(m)
                tmp << ((n-level2[m])*region[name][0]*region[name][1]*10**-12*b).round(3)
            end
            result << tmp
        end
        result.sort_by!{|x| x[0]}
        # path = '/Users/baoxi/Workspace/temp/'
        path = '/mnt/share/Temp/air_capacity_langfangshi/'
        filename = stime.strftime("%Y-%m-%d_%H").to_s+'.txt'
        f = File.open(path+filename,'w')
        f.puts(result.map{|x| x.join(',')})
        f.close
    end
    
    def mix_height(aqi)
        #计算混合层高度衰减系数
        case aqi
        when (0..50)
            37
        when (50..100)
            35
        when (100..150)
            30
        when (150..200)
            25
        when (200..1000)
            20
        else
            0
        end
    end
end
