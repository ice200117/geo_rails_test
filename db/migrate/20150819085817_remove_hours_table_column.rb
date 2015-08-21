class RemoveHoursTableColumn < ActiveRecord::Migration
  def change
  	remove_column :temp_lf_hours, :windspeed
    remove_column :temp_hb_hours, :windspeed
    remove_column :temp_sfcities_hours, :windspeed

    remove_column :temp_lf_hours, :humi
    remove_column :temp_hb_hours, :humi
    remove_column :temp_sfcities_hours, :humi

    remove_column :temp_lf_hours, :temp
    remove_column :temp_hb_hours, :temp
    remove_column :temp_sfcities_hours, :temp
  end
end
