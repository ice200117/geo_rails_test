class AddCountyRefToEnterprise < ActiveRecord::Migration
  def change
    add_reference :enterprises, :county, index: true
  end
end
