class ModifyMonitorPointDataTableId < ActiveRecord::Migration
  def change
	  rename_column(:monitor_point_hours,:point_id,:monitor_point_id)
	  rename_column(:monitor_point_days,:point_id,:monitor_point_id)
	  rename_column(:monitor_point_months,:point_id,:monitor_point_id)
	  rename_column(:monitor_point_years,:point_id,:monitor_point_id)
  end
end
