class TempSfcitiesMonth < ActiveRecord::Base
	validates :city_id, uniqueness: { scope: :data_real_time,
    message: "数据重复！" }
	belongs_to :city
	def get_rank_chart_data(name='qinhuangdaoshi',stime='20160606'.to_time,etime='20160607'.to_time)
		#获取月数据排名
		unless Custom::Redis.get("get_rank_chart_data_day")
			data = City.find_by_city_name_pinyin(name).temp_sfcities_months.where(data_real_time: (stime..etime)).to_a.group_by_month(&:data_real_time).as_json
			data.map do |k,v|
				tmp = v.max_by{|x| x['data_real_time']}
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
				tmp['city']=name
			end
			Custom::Redis.set("get_rank_chart_data_month",data,3600*24)
		end
		Custom::Redis.get('get_rank_chart_data_month')
		byebug
	end

	def self.city_rank(cityNamePinyin)
		#获取
		City.find_by_city_name_pinyin(cityNamePinyin).temp_sfcities_months.last.rank
	end
		
end
