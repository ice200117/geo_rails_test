class AddDataRealTimeToTempSfcitiesDay < ActiveRecord::Migration
  def change
    add_column :temp_sfcities_days, :data_real_time, :datetime
  end
end
