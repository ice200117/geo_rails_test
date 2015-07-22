class AddDataRealTimeToTempLfYear < ActiveRecord::Migration
  def change
    add_column :temp_lf_years, :data_real_time, :datetime
  end
end
