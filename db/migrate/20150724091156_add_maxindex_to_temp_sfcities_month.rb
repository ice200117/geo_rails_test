class AddMaxindexToTempSfcitiesMonth < ActiveRecord::Migration
  def change
  	add_column :temp_sfcities_months, :maxindex, :integer
  end
end
