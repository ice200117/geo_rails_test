class ModifyDaysTable < ActiveRecord::Migration
  def change
  	add_column :temp_lf_days, :weather, :string
    add_column :temp_jjj_days, :weather, :string
    add_column :temp_sfcities_days, :weather, :string

  	add_column :temp_lf_days, :temp, :float
    add_column :temp_jjj_days, :temp, :float
    add_column :temp_sfcities_days, :temp, :float

    add_column :temp_lf_days, :humi, :float
    add_column :temp_jjj_days, :humi, :float
    add_column :temp_sfcities_days, :humi, :float

    add_column :temp_lf_days, :winddirection, :string
    add_column :temp_jjj_days, :winddirection, :string
    add_column :temp_sfcities_days, :winddirection, :string

    add_column :temp_lf_days, :windspeed, :float
    add_column :temp_jjj_days, :windspeed, :float
    add_column :temp_sfcities_days, :windspeed, :float

    add_column :temp_lf_days, :windscale, :float
    add_column :temp_jjj_days, :windscale, :float
    add_column :temp_sfcities_days, :windscale, :float
  end
end
