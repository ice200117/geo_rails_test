class TempSfcitiesYear < ActiveRecord::Base
	validates :city_id, uniqueness: { scope: :data_real_time,
    message: "数据重复！" }
	belongs_to :city

	def self.city_rank(cityNamePinyin)
		City.find_by_city_name_pinyin(cityNamePinyin).temp_sfcities_years.last.rank
	end
end
