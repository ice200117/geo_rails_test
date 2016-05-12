class AddRankColumn < ActiveRecord::Migration
  def change
	  add_column :temp_hb_hours,:rank,:integer
	  add_column :temp_jjj_days,:rank,:integer
	  add_column :temp_jjj_months,:rank,:integer
	  add_column :temp_jjj_years,:rank,:integer
	  add_column :temp_sfcities_hours,:rank,:integer
	  add_column :temp_sfcities_days,:rank,:integer
	  add_column :temp_sfcities_months,:rank,:integer
	  add_column :temp_sfcities_years,:rank,:integer
	  add_column :monitor_point_hours,:rank,:integer
	  add_column :monitor_point_days,:rank,:integer
	  add_column :monitor_point_months,:rank,:integer
	  add_column :monitor_point_years,:rank,:integer
	  add_column :temp_bd_days,:rank,:integer
	  add_column :temp_bd_hours,:rank,:integer
	  add_column :temp_bd_months,:rank,:integer
	  add_column :temp_bd_years,:rank,:integer
	  add_column :temp_lf_days,:rank,:integer
	  add_column :temp_lf_hours,:rank,:integer
	  add_column :temp_lf_months,:rank,:integer
	  add_column :temp_lf_years,:rank,:integer
  end
end
