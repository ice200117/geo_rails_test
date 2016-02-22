class MonitorPointHourDeletePm1024h < ActiveRecord::Migration
  def change
	  remove_column(:monitor_point_hours,:pm10_24h)
  end
end
