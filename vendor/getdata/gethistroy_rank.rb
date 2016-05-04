require_relative './common.rb'

#历史脚本通用方法
def histroy_common(stime,etime,city_list,model)
	while stime<etime
		common_get_month_year(city_list,model,stime)
		stime += 60*60*24
	end
end

h=Hash.new
oneday = 60*60*24
time = Time.now
stime=time.years_ago(1).beginning_of_year
etime=time.yesterday.end_of_day

#廊坊日数据
# stime=time.years_ago(1).beginning_of_year
# while stime<etime
# 	hs=ten_times_test(TempLfDay,'lf_history_data','','',stime)  
# 	save_db(change_diff_cityname(hs),TempLfDay) if hs != false
# 	stime+=oneday
# end

#廊坊月数据
# stime=time.years_ago(1).beginning_of_year
# histroy_common(stime,etime,'langfang',TempLfMonth)

#廊坊年数据
# stime=time.years_ago(1).beginning_of_year
# histroy_common(stime,etime,'langfang',TempLfYear)

#京津冀日数据
stime=time.years_ago(1).beginning_of_year
while stime<etime
	hs=ten_times_test('TempJjjDay','history_74',{secret:'JINGJINJIDATA',type:'DAY',date:stime})  
	save_db(hs,TempJjjDay) if hs != false
	stime+=oneday
end

#京津冀月数据
stime=time.years_ago(1).beginning_of_year
histroy_common(stime,etime,'jjj',TempJjjMonth)

#京津冀年数据
stime=time.years_ago(1).beginning_of_year
histroy_common(stime,etime,'jjj',TempJjjYear)

#74城市日数据
stime=time.beginning_of_year
while stime<etime
	hs=ten_times_test('TempSfcitiesDay','history_74',{secret:'CHINADATA',type:'DAY',date:stime})
	save_db(hs,TempSfcitiesDay) if hs != false
	stime+=oneday
end

#74城市月数据
stime=time.beginning_of_year
histroy_common(stime,etime,'china_city_74',TempSfcitiesMonth)

#74城市年数据
stime=time.beginning_of_year
histroy_common(stime,etime,'china_city_74',TempSfcitiesYear)
