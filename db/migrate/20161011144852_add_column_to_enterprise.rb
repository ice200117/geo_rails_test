class AddColumnToEnterprise < ActiveRecord::Migration
  def change
  	add_column :enterprises, :en_category, :string
  	add_column :enterprises, :nmvoc, :float
  	add_column :enterprises, :co, :float
  	add_column :enterprises, :nh3, :float
  	add_column :enterprises, :pm10, :float
  	add_column :enterprises, :pm25, :float
  	add_column :enterprises, :bc, :float
  	add_column :enterprises, :oc, :float
  end
end
