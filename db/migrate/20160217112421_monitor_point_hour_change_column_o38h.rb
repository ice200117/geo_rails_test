class MonitorPointHourChangeColumnO38h < ActiveRecord::Migration
  def change
	  rename_column(:monitor_point_hours,:o3_8h,:O3_8h)
  end
end
