class TempSfcitiesHour < ActiveRecord::Base
  belongs_to :city
  validates :city_id, uniqueness: { scope: :data_real_time,
    message: "数据重复！" }
end
