class MonitorPointHourAddColumnPm1024hAndO38h < ActiveRecord::Migration
  def change
	  add_column(:monitor_point_hours,:pm10_24h,:integer)
	  add_column(:monitor_point_hours,:o3_8h,:integer)
  end
end
