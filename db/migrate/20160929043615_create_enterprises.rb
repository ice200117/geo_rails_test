class CreateEnterprises < ActiveRecord::Migration
  def change
    create_table :enterprises do |t|
      t.string "en_name"
      t.float   "latitude"	
      t.float   "longitude"
      t.float	"dust_concentration"
      t.float 	"dust_convert"
      t.float	"dust_discharge"
      t.float	"so2_concentration"
      t.float 	"so2_convert"
      t.float	"so2_discharge"
      t.float	"nox_concentration"
      t.float 	"nox_convert"
      t.float	"nox_discharge"
      t.float	"temperature"
      t.float	"discharge_height"
      t.timestamps
    end
  end
end
