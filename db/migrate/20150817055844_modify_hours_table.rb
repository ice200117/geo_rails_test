class ModifyHoursTable < ActiveRecord::Migration
  def up
	  rename_column("temp_lf_hours","quality","level")
	  rename_column("temp_hb_hours","quality","level")
	  rename_column("temp_sfcities_hours","quality","level")

	  rename_column("temp_lf_hours","main_pollutant","main_pol")
	  rename_column("temp_hb_hours","main_pollutant","main_pol")
	  rename_column("temp_sfcities_hours","main_pollutant","main_pol")
  end
end
