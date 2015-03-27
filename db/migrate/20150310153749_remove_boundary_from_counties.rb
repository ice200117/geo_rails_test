class RemoveBoundaryFromCounties < ActiveRecord::Migration
  def change
    remove_column :counties, :boundary, :polygon
    add_column :counties, :boundary, :multi_polygon
  end
end
