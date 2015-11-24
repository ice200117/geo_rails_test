class ChinaCitiesHour < ActiveRecord::Base
	belongs_to :cities
	validates_uniqueness_of :city_id, :scope => :data_real_time
end
