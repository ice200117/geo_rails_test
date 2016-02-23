class ModifyMonitorPointHourO38Htype < ActiveRecord::Migration
  def change
	  change_column(:monitor_point_hours,:O3_8h,:float)
  end
end
