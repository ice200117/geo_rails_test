# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150403033734) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "cities", force: true do |t|
    t.string  "city_name"
    t.string  "city_name_pinyin"
    t.integer "post_number"
    t.float   "latitude"
    t.spatial "lonlat",           limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.float   "longitude"
  end

  create_table "counties", force: true do |t|
    t.string   "name"
    t.float    "area"
    t.float    "perimeter"
    t.integer  "adcode"
    t.float    "centroid_y"
    t.float    "centroid_x"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.spatial  "boundary",   limit: {:srid=>0, :type=>"multi_polygon"}
  end

  create_table "forecast_points", force: true do |t|
    t.datetime "publish_date"
    t.datetime "forecast_date"
    t.float    "pm25"
    t.float    "pm10"
    t.float    "SO2"
    t.float    "CO"
    t.float    "NO2"
    t.float    "O3"
    t.float    "AQI"
    t.float    "VIS"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.spatial  "latlon",        limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.float    "longitude"
    t.float    "latitude"
  end

  create_table "hourly_city_forecast_air_qualities", force: true do |t|
    t.integer  "city_id"
    t.datetime "publish_datetime"
    t.datetime "forecast_datetime"
    t.float    "AQI"
    t.string   "main_pol"
    t.integer  "grade"
    t.float    "pm25"
    t.float    "pm10"
    t.float    "SO2"
    t.float    "CO"
    t.float    "NO2"
    t.float    "O3"
    t.float    "VIS"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", force: true do |t|
    t.string   "name"
    t.spatial  "latlon",     limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
