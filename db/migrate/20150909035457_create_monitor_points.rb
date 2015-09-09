class CreateMonitorPoints < ActiveRecord::Migration
  def change
    create_table :monitor_points do |t|
      t.string  "city_id"
      t.string  "region"
      t.string  "pointname"
      t.string  "level"
      t.float   "latitude"
      t.float   "longitude"
      t.timestamps
    end
  end
end
