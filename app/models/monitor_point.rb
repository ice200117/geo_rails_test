class MonitorPoint < ActiveRecord::Base
	belongs_to :city
	has_many :monitor_point_hours
end
