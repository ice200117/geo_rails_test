class ChangeColumnType < ActiveRecord::Migration
  def change

  	change_column :temp_lf_days, :windscale, :integer
    change_column :temp_jjj_days, :windscale, :integer
    change_column :temp_sfcities_days, :windscale, :integer

    change_column :temp_lf_days, :windspeed, :integer
    change_column :temp_jjj_days, :windspeed, :integer
    change_column :temp_sfcities_days, :windspeed, :integer

    change_column :temp_lf_days, :humi, :integer
    change_column :temp_jjj_days, :humi, :integer
    change_column :temp_sfcities_days, :humi, :integer

    change_column :temp_lf_days, :temp, :integer
    change_column :temp_jjj_days, :temp, :integer
    change_column :temp_sfcities_days, :temp, :integer

    change_column :temp_lf_hours, :windscale, :integer
    change_column :temp_hb_hours, :windscale, :integer
    change_column :temp_sfcities_hours, :windscale, :integer

    
  end
end
