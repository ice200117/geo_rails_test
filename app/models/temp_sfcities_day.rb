class TempSfcitiesDay < ActiveRecord::Base
	validates :city_id, uniqueness: { scope: :data_real_time,
								   message: "数据重复！" }
	belongs_to :city
	def self.get_rank_chart_data(name,stime,etime)
		#获取日数据排名
		data = Custom::Redis.get('get_rank_chart_data_day')
		if data
			data
		else
			data = City.find_by_city_name(name).temp_sfcities_days.select("AQI,main_pol,data_real_time,rank").where(data_real_time: (stime..etime)).as_json
			data.map do |l|
				l['lastrank'] = 75 - l['rank'] if l['rank']
				l['city']=name
				l['time']=l['data_real_time'].strftime('%Y-%m-%d')
			end
			rankdata={total: data.length,rows: data}
			Custom::Redis.set("get_rank_chart_data_day",rankdata,3600*24)
			
		end
	end

	def self.city_rank(cityNamePinyin)
		City.find_by_city_name_pinyin(cityNamePinyin).temp_sfcities_days.last.rank
	end
end
