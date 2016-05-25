class TempSfcitiesHour < ActiveRecord::Base
  belongs_to :city
  validates :city_id, uniqueness: { scope: :data_real_time,
    message: "数据重复！" }
  def city_rank(cityNamePinyin)
	  City.find_by_city_name_pinyin('cityNamePinyin').temp_sfcities_hours.last.rank
  end
end
