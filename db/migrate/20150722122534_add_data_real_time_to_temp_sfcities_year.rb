class AddDataRealTimeToTempSfcitiesYear < ActiveRecord::Migration
  def change
    add_column :temp_sfcities_years, :data_real_time, :datetime
  end
end
