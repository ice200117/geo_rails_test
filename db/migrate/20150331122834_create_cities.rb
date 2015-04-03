class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :city_name
      t.string :city_name_pinyin
      t.integer :post_number
      t.float :longtitude
      t.float :latitude
      t.point :lonlat, :geographic => true
    end
  end
end
