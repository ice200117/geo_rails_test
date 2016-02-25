class MonitorPointDataTableAddColumnCityId < ActiveRecord::Migration
  def change
	  add_column(:monitor_point_hours,:city_id,:integer)
	  add_column(:monitor_point_days,:city_id,:integer)
	  add_column(:monitor_point_months,:city_id,:integer)
	  add_column(:monitor_point_years,:city_id,:integer)
  end
end
