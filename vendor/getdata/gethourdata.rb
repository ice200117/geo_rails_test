require_relative './common.rb'
require_relative './get_qinhuangdao_data.rb'
require_relative './all_sites.rb'
require_relative './fix_forecast_by_least_square.rb'
require_relative '../replace_temp_table_from_hourly'
#require_relative '../fore_fix/fore_fix_9km.rb'
hs=Hash.new
oneday=60*60*24
stime = Time.now.beginning_of_hour 
etime = Time.now.end_of_hour

#全国城市实时数据
hs = Hash.new
hs[:secret] = "70ad4cb02984355c0f08f2e84be72c9c"
hs[:method] = "GETCITYDATA"
hs[:type]='HOUR'
hs = ten_times_test(ChinaCitiesHour,'all_city_by_hour',hs)
save_db(hs,ChinaCitiesHour)

# 获取全国站点数据
AllSite::Option.new.save

#保定实时数据
# hs = ten_times_test(TempBdHour,'shishi_rank_data','BAODINGRANK','HOUR',nil)
# save_db(hs,TempBdHour) if hour_data_common(hs,TempBdHour)

#廊坊实时数据
hs=ten_times_test(TempLfHour,'shishi_74',{secret:'LANGFANGRANK',type:'HOUR'})
save_db(hs,TempLfHour)
TempLfHour.new.atmospheric_volume_superscalar
#
# 秦皇岛小时数据
Qinhuangdao::Qinhuangdao.new.hour

# tmp=MonitorPointHour.last.data_real_time
# stime=tmp.beginning_of_hour
# etime=tmp.end_of_hour
# Custom::Redis.set('qhd_hour',MonitorPointHour.where(city_id: 11,data_real_time: (stime..etime)))

#河北实时数据
hs=ten_times_test(TempHbHour,'shishi_74',{secret:'HEBEIRANK',type:'HOUR'})
save_db(hs,TempHbHour)

#74城市实时数据
hs=ten_times_test(TempSfcitiesHour,'shishi_74',{secret:'CHINARANK',type:'HOUR'})
save_db(hs,TempSfcitiesHour)

fix_forecast_by_least_square()

replace_eight_hours(stime,etime)
system('curl http://www.izhenqi.cn/crawler/aqi_forecast_city_jjj.php')

#获取当前全国城市后，调用修正算法
# response = HTTParty.get("http://60.10.135.153:3000/bar.json")
# data = JSON.parse(response.body)
# if data != nil
# 	data.delete_if{|x| x[3]<49} #去掉差值低于50的城市
# 	data.each do |i|
# 		c=City.find_by_city_name(i[0]) 
# 		next if c==nil
# 		city(c)  #调起fore_fix_one_city中的city方法
# 		save_in_db(c) #调用rd_hourly_aqi_every_hour中的写入方法
# 	end
#end
