class AddDataRealTimeToTempLfMonth < ActiveRecord::Migration
  def change
    add_column :temp_lf_months, :data_real_time, :datetime
  end
end
