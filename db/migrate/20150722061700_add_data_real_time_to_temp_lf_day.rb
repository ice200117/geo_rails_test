class AddDataRealTimeToTempLfDay < ActiveRecord::Migration
  def change
    add_column :temp_lf_days, :data_real_time, :datetime
  end
end
