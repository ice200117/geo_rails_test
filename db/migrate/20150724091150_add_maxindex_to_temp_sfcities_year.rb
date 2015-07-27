class AddMaxindexToTempSfcitiesYear < ActiveRecord::Migration
  def change
  	add_column :temp_sfcities_years, :maxindex, :integer
  end
end
