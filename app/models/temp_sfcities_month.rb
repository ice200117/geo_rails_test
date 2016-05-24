class TempSfcitiesMonth < ActiveRecord::Base
	validates :city_id, uniqueness: { scope: :data_real_time,
    message: "数据重复！" }
	def get_rank_chart_data(name,stime,etime)
		#获取日数据排名
		if Custom::Redis.get("get_rank_chart_data_day")
		else
			data = City.find_by_city_name(name).temp_sfcities_months.select("AQI,main_pol,data_real_time,rank").where(data_real_time: (stime..etime)).group_by_month(&:data_real_time)

			data.each do |l|
				l['lastrank'] = 75 - l['rank'] if l['rank']
				l['city']=name
			end
			Custom::Redis.set("get_rank_chart_data_day",data,3600*24)
			data
		end
	end
end
