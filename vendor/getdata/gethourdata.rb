require_relative './common.rb'
def hour_data_common(hs,model)
	if hs != false 
		if model.last.nil? || hs[:time].to_time>model.last.data_real_time
			return true
		else
			return false
		end
	else
		return false
	end
end
(1..2)
hs=Hash.new
oneday=60*60*24

#保定实时数据
# hs = ten_times_test(TempBdHour,'shishi_rank_data','BAODINGRANK','HOUR',nil)
# save_db(hs,TempBdHour) if hour_data_common(hs,TempBdHour)

#廊坊实时数据
# hs=ten_times_test(TempLfHour,'shishi_rank_data','LANGFANGRANK','HOUR',nil)
# save_db(change_diff_cityname(hs),TempLfHour) if hour_data_common(hs,TempLfHour)

#河北实时数据
# hs=ten_times_test(TempHbHour,'shishi_rank_data','HEBEIRANK','HOUR',nil)
# save_db(hs,TempHbHour) if hour_data_common(hs,TempHbHour)

#74城市实时数据
# hs=ten_times_test(TempSfcitiesHour,'shishi_rank_data','CHINARANK','HOUR',nil)
# save_db(hs,TempSfcitiesHour) if hour_data_common(hs,TempSfcitiesHour) 

#全国城市实时数据
hs = Hash.new
hs[:secret] = "70ad4cb02984355c0f08f2e84be72c9c"
hs[:method] = "GETCITYDATA"
hs = ten_times_test(ChinaCitiesHour,'all_city_by_hour',hs,'HOUR',nil)
save_db(hs,ChinaCitiesHour)
