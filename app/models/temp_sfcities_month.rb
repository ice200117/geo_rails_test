class TempSfcitiesMonth < ActiveRecord::Base
	validates :city_id, uniqueness: { scope: :data_real_time,
    message: "数据重复！" }
	belongs_to :city
	def self.get_rank_chart_data(name,stime,etime)
		#获取月数据排名
		unless Custom::Redis.get("get_rank_chart_data_month")
			data = Array.new
			d = City.find_by_city_name(name).temp_sfcities_months.where(data_real_time: (stime..etime)).order('data_real_time asc').to_a.group_by_month(&:data_real_time).as_json
			d.each do |k,v|
				tmp = v.max_by{|x| x['data_real_time']}
				# tmp['rank'] = '' if tmp['rank'].nil?
				# tmp.delete_if{|x| x['rank'].nil? }
				if tmp['data_real_time'].to_time.day == tmp['data_real_time'].to_time.end_of_month.day
					tmp['lastrank'] = (tmp['rank']=='') ? '' : (75 - tmp['rank'])
					tmp['time'] = tmp['data_real_time'].strftime("%Y%m")
					tmp['primary_pollutant'] = tmp['main_pol']
					tmp['complexindex'] = tmp['zonghezhishu'].round(3)
				else
					tmp['foretime'] = tmp['data_real_time'].strftime('%Y%m')
					tmp['forerank'] = tmp['rank']
					tmp['forelastrank'] = (tmp['rank']=='') ? '' : (75 - tmp['rank'])
					tmp['forecomplexindex'] = tmp['zonghezhishu'].round(3)
					tmp['foreprimary_pollutant'] = tmp['main_pol']
				end
				tmp['city']=name
				data << tmp
			end
			rankdata = {total:data.length,rows: data}
			Custom::Redis.set("get_rank_chart_data_month",rankdata,3600*24)
		else
			Custom::Redis.get('get_rank_chart_data_month')
		end
	end

	def self.city_rank(cityNamePinyin)
		#获取
		City.find_by_city_name_pinyin(cityNamePinyin).temp_sfcities_months.last.rank
	end
		
end
