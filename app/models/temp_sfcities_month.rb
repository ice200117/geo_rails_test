class TempSfcitiesMonth < ActiveRecord::Base
	validates :city_id, uniqueness: { scope: :data_real_time,
    message: "数据重复！" }
	belongs_to :city
	def get_rank_chart_data(name,stime,etime)
		#获取月数据排名
		unless Custom::Redis.get("get_rank_chart_data_day")
			data = City.find_by_city_name(name).temp_sfcities_months.select(
				"AQI,main_pol,data_real_time,rank").where(data_real_time: (stime..etime)).group_by_month(&:data_real_time)
			data.map do |k,v|
				tmp = v.max_by{|x| x['data_real_time']}
				v.delete_if{|x| x<tmp['data_real_time']}
				if tmp['data_real_time'].to_time.day == tmp['data_real_time'].to_time.end_of_month.day
					tmp['lastrank'] = 75 - tmp['rank']
					tmp['time'] = tmp['data_real_time']
					tmp['primary_pollutant'] = tmp['main_pol']
				else
					tmp['foretime'] = tmp['data_real_time']
					tmp['forerank'] = tmp['rank']
					tmp['forelastrank'] = 75 - tmp['rank']
					tmp['forecomplexindex'] = tmp['complexindex']
					tmp['foreprimary_pollutant'] = tmp['main_pol']
				end
				l['lastrank'] = 75 - l['rank'] if l['rank']
				l['city']=name
			end
			Custom::Redis.set("get_rank_chart_data_day",data,3600*24)
		end
		Custom::Redis.get('get_rank_chart_data')
	end

	def self.city_rank(cityNamePinyin)
		City.find_by_city_name_pinyin(cityNamePinyin).temp_sfcities_months.last.rank
	end
		
end
