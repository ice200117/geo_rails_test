class ModifyMonitorPoints < ActiveRecord::Migration
  def change
	  remove_index :monitor_points, :post_number
  end
end
