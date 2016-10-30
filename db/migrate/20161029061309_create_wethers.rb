class CreateWethers < ActiveRecord::Migration
  def change
    create_table :wethers do |t|

      t.timestamps
    end
  end
end
