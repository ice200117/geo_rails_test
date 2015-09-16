class TempHbHour < ActiveRecord::Base
<<<<<<< HEAD
	validates :city_id, uniqueness: { scope: :data_real_time,
    message: "数据重复！" }
=======
  validates :city_id, uniqueness: { scope: :data_real_time }
>>>>>>> 5d725d87b4e0ee4172154ac5850914313493888b
end
