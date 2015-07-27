class DropTempLfHour < ActiveRecord::Migration
  def change
  	drop_table :temp_lf_hours
  	drop_table :temp_lves
  end
end
