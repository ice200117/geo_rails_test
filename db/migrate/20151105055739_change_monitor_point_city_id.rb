class ChangeMonitorPointCityId < ActiveRecord::Migration
  def change
	  remove_column :monitor_points,:city_id
	  add_column :monitor_points,:city_id,:integer
  end
end
