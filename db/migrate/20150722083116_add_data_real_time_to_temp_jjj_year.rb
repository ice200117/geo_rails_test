class AddDataRealTimeToTempJjjYear < ActiveRecord::Migration
  def change
    add_column :temp_jjj_years, :data_real_time, :datetime
  end
end
