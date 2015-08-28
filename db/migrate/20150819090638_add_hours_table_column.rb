class AddHoursTableColumn < ActiveRecord::Migration
  def change
  	add_column :temp_lf_hours, :windspeed, :integer
    add_column :temp_hb_hours, :windspeed, :integer
    add_column :temp_sfcities_hours, :windspeed, :integer

    add_column :temp_lf_hours, :humi, :integer
    add_column :temp_hb_hours, :humi, :integer
    add_column :temp_sfcities_hours, :humi, :integer

    add_column :temp_lf_hours, :temp, :integer
    add_column :temp_hb_hours, :temp, :integer
    add_column :temp_sfcities_hours, :temp, :integer
  end
end
