class AddZonghezhishuWindscaleToHoursTable < ActiveRecord::Migration
  def change
  	add_column :temp_lf_hours, :zonghezhishu, :float
    add_column :temp_hb_hours, :zonghezhishu, :float
    add_column :temp_sfcities_hours, :zonghezhishu, :float

    add_column :temp_lf_hours, :windscale, :float
    add_column :temp_hb_hours, :windscale, :float
    add_column :temp_sfcities_hours, :windscale, :float
  end
end
