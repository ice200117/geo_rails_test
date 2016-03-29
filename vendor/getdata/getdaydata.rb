require_relative './common.rb'

def day_data_common(hs,model)
	if hs != false 
		if model.last.nil? || hs[:time].to_time > model.last.data_real_time
			return true
		else
			return false
		end
	else
		return false
	end
end

hs=Hash.new
time=Time.now.yesterday

#保定日数据
# hs=ten_times_test(TempBdDay,'shishi_rank_data','BAODINGRANK','DAY',nil)
# save_db(hs,TempBdDay) if day_data_common(hs,TempBdDay) 

#保定月数据
# common_get_month_year('baoding',TempBdMonth,time)

#保定年数据
# common_get_month_year('baoding',TempBdYear,time)

#廊坊日数据
# hs=ten_times_test(TempLfDay,'shishi_rank_data','LANGFANGRANK','DAY',nil)
# save_db(change_diff_cityname(hs),TempLfDay) if day_data_common(hs,TempLfDay)

#廊坊月数据
# common_get_month_year('langfang',TempLfMonth,time)

#廊坊年数据
# common_get_month_year('langfang',TempLfYear,time)

#京津冀日数据
hs=ten_times_test(TempJjjDay,'china_history_data','JINGJINJIDATA','DAY',time)
save_db(hs,TempJjjDay) if day_data_common(hs,TempJjjDay)

#京津冀月数据
common_get_month_year('jjj',TempJjjMonth,time)

#京津冀年数据
common_get_month_year('jjj',TempJjjYear,time)

#74城市日数据
hs=ten_times_test(TempSfcitiesDay,'shishi_china_rank_data','CHINARANK','DAY',nil)
save_db(hs,TempSfcitiesDay) if day_data_common(hs,TempSfcitiesDay)

#74城市月数据
common_get_month_year('china_city_74',TempSfcitiesMonth,time)

#74城市年数据
common_get_month_year('china_city_74',TempSfcitiesYear,time)
