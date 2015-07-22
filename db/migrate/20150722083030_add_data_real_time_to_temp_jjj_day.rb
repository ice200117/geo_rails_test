class AddDataRealTimeToTempJjjDay < ActiveRecord::Migration
  def change
    add_column :temp_jjj_days, :data_real_time, :datetime
  end
end
