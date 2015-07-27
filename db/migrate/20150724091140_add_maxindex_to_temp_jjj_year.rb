class AddMaxindexToTempJjjYear < ActiveRecord::Migration
  def change
  	add_column :temp_jjj_years, :maxindex, :integer
  end
end
