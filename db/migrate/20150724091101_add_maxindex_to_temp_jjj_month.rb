class AddMaxindexToTempJjjMonth < ActiveRecord::Migration
  def change
  	add_column :temp_jjj_months, :maxindex, :integer
  end
end
