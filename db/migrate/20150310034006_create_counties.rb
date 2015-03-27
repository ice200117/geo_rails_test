class CreateCounties < ActiveRecord::Migration
  def change
    create_table :counties do |t|
      t.string   :name
      t.float    :area
      t.float    :perimeter
      t.integer  :adcode
      t.float    :centroid_y
      t.float    :centroid_x
      t.polygon  :boundary, :srid => 3785

      t.timestamps
    end
    change_table :counties do |t|
      t.index :boundary, :spatial => true
    end
  end
end
