class ChangeAllColumnType < ActiveRecord::Migration
  def change
  	change_column :day_cities, :level, :string
    change_column :temp_bd_days, :level, :string
    change_column :temp_bd_months, :level, :string

    change_column :temp_bd_years, :level, :string
    change_column :temp_jjj_days, :level, :string
    change_column :temp_jjj_months, :level, :string

    change_column :temp_jjj_years, :level, :string
    change_column :temp_lf_days, :level, :string
    change_column :temp_lf_months, :level, :string

    change_column :temp_lf_years, :level, :string
    change_column :temp_sfcities_days, :level, :string
    change_column :temp_sfcities_months, :level, :string

    change_column :temp_sfcities_years, :level, :string
  end
end
