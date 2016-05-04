class CreateMonitorData < ActiveRecord::Migration
  def change
    create_table :monitor_data do |t|

      t.timestamps
    end
  end
end
