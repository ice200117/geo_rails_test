class AddDataRealTimeToTempJjjMonth < ActiveRecord::Migration
  def change
    add_column :temp_jjj_months, :data_real_time, :datetime
  end
end
