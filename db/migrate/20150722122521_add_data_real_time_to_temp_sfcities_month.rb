class AddDataRealTimeToTempSfcitiesMonth < ActiveRecord::Migration
  def change
    add_column :temp_sfcities_months, :data_real_time, :datetime
  end
end
