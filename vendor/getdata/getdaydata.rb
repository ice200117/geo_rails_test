require_relative './common.rb'
# require_relative './get_qinhuangdao_data.rb'
# require_relative './calculate_sfcities_rank.rb'
# require_relative './bd_day.rb'

time=Time.now.yesterday

#秦皇岛日数据
# Qinhuangdao::Qinhuangdao.new.day

# tmp=MonitorPointDay.last.data_real_time
# stime=tmp.beginning_of_day
# etime=tmp.end_of_day
# Custom::Redis.set('qhd_hour',MonitorPointDay.where(city_id: 11,data_real_time: (stime..etime)))

Qinhuangdao::Qinhuangdao.new.month
Qinhuangdao::Qinhuangdao.new.year

#保定日数据
# hs=ten_times_test('TempBdDay','shishi_74',{secret:'BAODINGRANK',type:'DAY'})
# save_db(hs,TempBdDay)

#保定月数据
# common_get_month_year('baoding',TempBdMonth,time)
# Qinhuangdao::Qinhuangdao.new.month
# Qinhuangdao::Qinhuangdao.new.year

#保定日数据
# hs=ten_times_test('TempBdDay','shishi_74',{secret:'BAODINGRANK',type:'DAY'})
# save_db(hs,TempBdDay)

#保定月数据
# common_get_month_year('baoding',TempBdMonth,time)

#保定年数据
# common_get_month_year('baoding',TempBdYear,time)

#廊坊日数据
# hs=ten_times_test('TempLfDay','shishi_74',{secret:'LANGFANGRANK',type:'DAY'})
# save_db(change_diff_cityname(hs),TempLfDay)

#廊坊月数据
# common_get_month_year('langfang',TempLfMonth,time)

#廊坊年数据
# common_get_month_year('langfang',TempLfYear,time)

#京津冀日数据
# time=Time.now.yesterday
# hs=ten_times_test('TempJjjDay','history_74',{secret:'JINGJINJIDATA',type:'DAY',date:time})
# save_db(hs,TempJjjDay)

#京津冀月数据
# common_get_month_year('jjj',TempJjjMonth,time)

#京津冀年数据
# common_get_month_year('jjj',TempJjjYear,time)

#74城市日数据
hs=ten_times_test('TempSfcitiesDay','shishi_rank_74',{secret:'eb3d87df64f2fa171dad1cfc9a8999b3',method:'GETDATA',name:'CHINA',type:'DAY'})
save_db(hs,TempSfcitiesDay) if hs

#74城市月数据
hs=ten_times_test("TempSfcitiesMonth",'zhzs_74',{secret:'CHINARANK',type:'MONTH'})
save_db(hs,TempSfcitiesMonth) if hs
# common_get_month_year('china_city_74',TempSfcitiesMonth,time)

#74城市年数据
hs=ten_times_test("TempSfcitiesYear",'zhzs_74',{secret:'CHINARANK',type:'YEAR'})
save_db(hs,TempSfcitiesYear) if hs
# common_get_month_year('china_city_74',TempSfcitiesYear,time)

model(TempSfcitiesMonth,time.beginning_of_day,time.end_of_day)
model(TempSfcitiesYear,time.beginning_of_day,time.end_of_day)

$redis.flushdb
