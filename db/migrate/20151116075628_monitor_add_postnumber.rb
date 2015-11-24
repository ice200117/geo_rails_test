class MonitorAddPostnumber < ActiveRecord::Migration
  def change
	  add_column :monitor_points, :post_number,:integer
	  add_index :monitor_points, :post_number
  end
end
