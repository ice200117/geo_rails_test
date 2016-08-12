class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string   :name
      t.float    :area
      t.float    :perimeter
      t.multi_polygon  :boundary, :srid => 3857

      t.timestamps
    end
    change_table :regions do |t|
      t.index :boundary, :spatial => true
    end
  end
end
