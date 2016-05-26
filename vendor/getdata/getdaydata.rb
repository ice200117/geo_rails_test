require_relative './common.rb'
require_relative './get_qinhuangdao_data.rb'

time=Time.now.yesterday
#秦皇岛日数据
# Qinhuangdao::Qinhuangdao.new.day

<<<<<<< HEAD
# tmp=MonitorPointDay.last.data_real_time
# stime=tmp.beginning_of_day
# etime=tmp.end_of_day
# Custom::Redis.set('qhd_hour',MonitorPointDay.where(city_id: 11,data_real_time: (stime..etime)))
=======
tmp=MonitorPointDay.last.data_real_time
stime=tmp.beginning_of_day
etime=tmp.end_of_day
<<<<<<< HEAD
Custom::Redis.set('qhd_hour',MonitorPointDay.where(city_id: 11,data_real_time: (stime..etime)))
>>>>>>> ce5e27a2008cecd374a76146f1dc85c49e44dc4b
=======
Custom::Redis.set('qhd_hour',MonitorPointDay.where("city_id = ? AND data_real_time >= ? AND data_real_time <= ?",11,stime,etime))
>>>>>>> 1a95773615b303289efe8ff636911f34b556dffb

# Qinhuangdao::Qinhuangdao.new.month
# Qinhuangdao::Qinhuangdao.new.year

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
<<<<<<< HEAD
<<<<<<< HEAD
# time=Time.now.yesterday
# hs=ten_times_test('TempJjjDay','history_74',{secret:'JINGJINJIDATA',type:'DAY',date:time})
# save_db(hs,TempJjjDay)
=======
hs=ten_times_test('TempJjjDay','china_history_data',{secret:'JINGJINJIDATA',type:'DAY',date:time})
save_db(hs,TempJjjDay)
>>>>>>> ce5e27a2008cecd374a76146f1dc85c49e44dc4b
=======
hs=ten_times_test('TempJjjDay','history_74',{secret:'JINGJINJIDATA',type:'DAY',date:time})
save_db(hs,TempJjjDay)
>>>>>>> 1a95773615b303289efe8ff636911f34b556dffb

#京津冀月数据
common_get_month_year('jjj',TempJjjMonth,time)

#京津冀年数据
common_get_month_year('jjj',TempJjjYear,time)

#74城市日数据
hs=ten_times_test('TempSfcitiesDay','shishi_rank_74',{secret:'CHINARANK',type:'DAY'})
save_db(hs,TempSfcitiesDay) if hs

#74城市月数据
<<<<<<< HEAD
<<<<<<< HEAD
hs=ten_times_test("TempSfcitiesMonth",'zhzs_74',{secret:'CHINARANK',type:'MONTH'})
save_db(hs,TempSfcitiesMonth) if hs
# common_get_month_year('china_city_74',TempSfcitiesMonth,time)

#74城市年数据
hs=ten_times_test("TempSfcitiesYear",'zhzs_74',{secret:'CHINARANK',type:'YEAR'})
save_db(hs,TempSfcitiesYear) if hs
# common_get_month_year('china_city_74',TempSfcitiesYear,time)
=======
common_get_month_year('china_city_74',TempSfcitiesMonth,time)
=======
common_get_month_year('china_city_74',TempSfcitiesMonth,time)

#74城市年数据
common_get_month_year('china_city_74',TempSfcitiesYear,time)
>>>>>>> 1a95773615b303289efe8ff636911f34b556dffb

#74城市年数据
common_get_month_year('china_city_74',TempSfcitiesYear,time)
>>>>>>> ce5e27a2008cecd374a76146f1dc85c49e44dc4b
