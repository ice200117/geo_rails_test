class ChinaCitiesHour < ActiveRecord::Base
	belongs_to :city
	validates_uniqueness_of :city_id, :scope => :data_real_time

	def self.today_avg(city_name_pinyin=nil,spe=:AQI)
		city_avg = {}
		if city_name_pinyin
			c = City.find_by_city_name_pinyin(city_name_pinyin)
			f = c.china_cities_hours.where(
				data_real_time: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).average(spe)
			city_avg[c.city_name] = f.round if f
		else
			cs = City.includes(:china_cities_hours).where(
				china_cities_hours: {data_real_time: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day})
			print cs.length
			cs.each do |cl|
				f = (cl.china_cities_hours.collect(&spe).sum / cl.china_cities_hours.length).to_i
				city_avg[cl.city_name] = f
			end
		end
		#puts city_avg
		city_avg
	end

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

	def self.history_data(city, start_time)
		d = city.china_cities_hours.group_by_day(:data_real_time, range: start_time..Time.now).average(:AQI)
		hs = {}
		d.each do |k,v|
			hs[[city.city_name+'监测值', k.strftime("%d%b")]] = v.round
		end
		hs
	end

	def self.history_data_hour(city, start_time)
		city.china_cities_hours.where(data_real_time: start_time..Time.now).order(:data_real_time).pluck(:data_real_time, :AQI)
	end

end
