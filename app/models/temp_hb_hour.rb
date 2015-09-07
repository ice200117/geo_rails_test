class TempHbHour < ActiveRecord::Base
  validates :city_id, uniqueness: { scope: :data_real_time }
end
