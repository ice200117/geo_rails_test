class DeleteMonitorPointsColumnPostNumber < ActiveRecord::Migration
  def change
	  remove_column :monitor_points,:post_number
	  add_index(:monitor_points,[:pointname,:city_id])
  end
end
