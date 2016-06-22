class MonitorPoint < ActiveRecord::Base
	belongs_to :city
	has_many :monitor_point_hours
	has_many :monitor_point_days
	validates :city_id, uniqueness: { scope: :pointname,message: "数据重复！" }
end
