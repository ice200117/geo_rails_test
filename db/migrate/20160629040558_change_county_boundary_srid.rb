class ChangeCountyBoundarySrid < ActiveRecord::Migration
  def change
    remove_column :counties, :boundary, :multi_polygon
    add_column :counties, :boundary, :multi_polygon, :srid => 3857
  end
end
