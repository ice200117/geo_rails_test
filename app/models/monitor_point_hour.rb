class MonitorPointHour < ActiveRecord::Base
	belongs_to :monitor_point
	validates_uniqueness_of :point_id, :scope => :data_real_time
	def today_one_city_by_cityid(cityid)
		sql_str=Array.new
		sql_str<<"data_real_time >=? AND data_real_time <=? AND city_id=?"
		sql_str<<Time.now.begin_of_day
		sql_str<<Time.now.end_of_day
		sql_str<<cityid
		data=MonitorPointHour.where(sql_str)
	end
end
