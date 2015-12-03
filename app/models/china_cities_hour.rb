class ChinaCitiesHour < ActiveRecord::Base
	belongs_to :cities
	validates_uniqueness_of :city_id, :scope => :data_real_time

	def self.get_real_monitor_data(city_name_pinyin)
		c = City.find_by_city_name_pinyin(city_name_pinyin)
		d = c.china_cities_hours.last
		data = {}
		data[:data_time] = d.data_real_time.strftime("%Y-%m-%d_%H")
		data[:city_name] = c.city_name
		data[:longitude] = c.longitude
		data[:latitude] = c.latitude
		data[:AQI] = d.AQI
		data[:SO2] = d.SO2
		data[:NO2] = d.NO2
		data[:O3] = d.O3
		data[:pm10] = d.pm10
		data[:pm25] = d.pm25
		data[:level] = d.level
		data[:main_pol] = d.main_pol
		data[:AQI] = d.AQI
		data
	end

	def self.get_all_real_data
		cs = City.includes(:china_cities_hours)
		data_arr = []
		cs.each do |c|
			d = c.china_cities_hours.last
			next unless d
			data = {}
			data[:data_time] = d.data_real_time.strftime("%Y-%m-%d_%H")
			data[:city_name] = c.city_name
			data[:longitude] = c.longitude
			data[:latitude] = c.latitude
			data[:AQI] = d.AQI
			data[:SO2] = d.SO2
			data[:NO2] = d.NO2
			data[:O3] = d.O3
			data[:pm10] = d.pm10
		    data[:pm25] = d.pm25
			data[:level] = d.level
			data[:main_pol] = d.main_pol
			data[:AQI] = d.AQI
			data_arr << data
		end

		data_arr
	end


end
