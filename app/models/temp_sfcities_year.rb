class TempSfcitiesYear < ActiveRecord::Base
	validates :city_id, uniqueness: { scope: :data_real_time,
    message: "数据重复！" }

	def city_rank(cityNamePinyin)
		City.find_by_city_name_pinyin('cityNamePinyin').temp_sfcities_yesrs.last.rank
	end
end
