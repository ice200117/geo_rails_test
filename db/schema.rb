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

ActiveRecord::Schema.define(version: 20161019043445) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "postgis_topology"
  enable_extension "fuzzystrmatch"
  enable_extension "postgis_tiger_geocoder"

  create_table "ann_forecast_data", force: true do |t|
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

  add_index "ann_forecast_data", ["city_id", "publish_datetime", "forecast_datetime"], :name => "index_ann_aqi_city_pubtime_foretime", :unique => true

  create_table "casein_admin_users", force: true do |t|
    t.string   "login",                           null: false
    t.string   "name"
    t.string   "email"
    t.integer  "access_level",        default: 0, null: false
    t.string   "crypted_password",                null: false
    t.string   "password_salt",                   null: false
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "login_count",         default: 0, null: false
    t.integer  "failed_login_count",  default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "time_zone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "china_cities_hours", force: true do |t|
    t.integer   "city_id"
    t.float     "SO2"
    t.float     "NO2"
    t.float     "CO"
    t.float     "O3"
    t.float     "pm10"
    t.float     "pm25"
    t.float     "AQI"
    t.string    "level"
    t.string    "main_pol"
    t.string    "quality"
    t.string    "weather"
    t.string    "temp"
    t.string    "humi"
    t.string    "winddirection"
    t.string    "windspeed"
    t.integer   "windscale"
    t.float     "zonghezhishu"
    t.timestamp "data_real_time", precision: 6
    t.timestamp "created_at",     precision: 6
    t.timestamp "updated_at",     precision: 6
  end

  create_table "cities", force: true do |t|
    t.string  "city_name"
    t.string  "city_name_pinyin"
    t.integer "post_number"
    t.float   "latitude"
    t.spatial "lonlat",           limit: {:srid=>4326, :type=>"geometry", :geographic=>true}
    t.float   "longitude"
    t.string  "province"
    t.string  "district"
    t.integer "cityid"
  end

  create_table "city_dailies", force: true do |t|
    t.integer  "city_id"
    t.date     "publish_time"
    t.float    "pm25"
    t.float    "pm10"
    t.float    "o3"
    t.float    "o3_8h"
    t.float    "co"
    t.float    "so2"
    t.float    "no2"
    t.float    "aqi"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "city_dailies", ["city_id"], :name => "index_city_dailies_on_city_id"

  create_table "city_hours", force: true do |t|
    t.integer  "city_id"
    t.float    "pm25"
    t.float    "pm10"
    t.float    "o3"
    t.float    "o3_8h"
    t.float    "co"
    t.float    "so2"
    t.float    "no2"
    t.float    "aqi"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "city_hours", ["city_id"], :name => "index_city_hours_on_city_id"

  create_table "counties", force: true do |t|
    t.string    "name"
    t.float     "area"
    t.float     "perimeter"
    t.integer   "adcode"
    t.float     "centroid_y"
    t.float     "centroid_x"
    t.timestamp "created_at",                                               precision: 6
    t.timestamp "updated_at",                                               precision: 6
    t.spatial   "boundary",   limit: {:srid=>3857, :type=>"multi_polygon"}
    t.integer   "city_id"
  end

  add_index "counties", ["city_id"], :name => "index_counties_on_city_id"

  create_table "day_cities", force: true do |t|
    t.integer   "city_id"
    t.float     "SO2"
    t.float     "NO2"
    t.float     "CO"
    t.float     "O3"
    t.float     "pm10"
    t.float     "pm25"
    t.float     "zonghezhishu"
    t.float     "AQI"
    t.string    "level"
    t.string    "main_pol"
    t.float     "SO2_change_rate"
    t.float     "NO2_change_rate"
    t.float     "CO_change_rate"
    t.float     "O3_change_rate"
    t.float     "pm10_change_rate"
    t.float     "pm25_change_rate"
    t.float     "zongheindex_change_rate"
    t.timestamp "created_at",              precision: 6
    t.timestamp "updated_at",              precision: 6
  end

  create_table "enterprises", force: true do |t|
    t.string   "en_name"
    t.float    "latitude"
    t.float    "longitude"
    t.float    "dust_concentration"
    t.float    "dust_convert"
    t.float    "dust_discharge"
    t.float    "so2_concentration"
    t.float    "so2_convert"
    t.float    "so2_discharge"
    t.float    "nox_concentration"
    t.float    "nox_convert"
    t.float    "nox_discharge"
    t.float    "temperature"
    t.float    "discharge_height"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "en_category"
    t.float    "nmvoc"
    t.float    "co"
    t.float    "nh3"
    t.float    "pm10"
    t.float    "pm25"
    t.float    "bc"
    t.float    "oc"
    t.integer  "city_id"
    t.integer  "county_id"
  end

  add_index "enterprises", ["city_id"], :name => "index_enterprises_on_city_id"
  add_index "enterprises", ["county_id"], :name => "index_enterprises_on_county_id"

  create_table "forecast_24s", force: true do |t|
    t.integer  "station_id"
    t.string   "pattern"
    t.datetime "publish_time"
    t.datetime "predict_time"
    t.float    "pm25"
    t.float    "pm10"
    t.float    "o3"
    t.float    "o3_8h"
    t.float    "co"
    t.float    "so2"
    t.float    "no2"
    t.float    "aqi"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "forecast_24s", ["station_id"], :name => "index_forecast_24s_on_station_id"

  create_table "forecast_48s", force: true do |t|
    t.integer  "station_id"
    t.string   "pattern"
    t.datetime "publish_time"
    t.datetime "predict_time"
    t.float    "pm25"
    t.float    "pm10"
    t.float    "o3"
    t.float    "o3_8h"
    t.float    "co"
    t.float    "so2"
    t.float    "no2"
    t.float    "aqi"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "forecast_48s", ["station_id"], :name => "index_forecast_48s_on_station_id"

  create_table "forecast_72s", force: true do |t|
    t.integer  "station_id"
    t.string   "pattern"
    t.datetime "publish_time"
    t.datetime "predict_time"
    t.float    "pm25"
    t.float    "pm10"
    t.float    "o3"
    t.float    "o3_8h"
    t.float    "co"
    t.float    "so2"
    t.float    "no2"
    t.float    "aqi"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "forecast_72s", ["station_id"], :name => "index_forecast_72s_on_station_id"

  create_table "forecast_96s", force: true do |t|
    t.integer  "station_id"
    t.string   "pattern"
    t.datetime "publish_time"
    t.datetime "predict_time"
    t.float    "pm25"
    t.float    "pm10"
    t.float    "o3"
    t.float    "o3_8h"
    t.float    "co"
    t.float    "so2"
    t.float    "no2"
    t.float    "aqi"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "forecast_96s", ["station_id"], :name => "index_forecast_96s_on_station_id"

  create_table "forecast_dailies", force: true do |t|
    t.integer  "station_id"
    t.string   "pattern"
    t.date     "publish_date"
    t.date     "predict_date"
    t.float    "pm25"
    t.float    "pm10"
    t.float    "o3"
    t.float    "o3_8h"
    t.float    "co"
    t.float    "so2"
    t.float    "no2"
    t.float    "aqi"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "forecast_dailies", ["station_id"], :name => "index_forecast_dailies_on_station_id"

  create_table "forecast_daily_data", force: true do |t|
    t.integer  "city_id"
    t.date     "publish_date"
    t.date     "forecast_date"
    t.integer  "max_forecast"
    t.integer  "min_forecast"
    t.string   "main_pollutant"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forecast_points", force: true do |t|
    t.timestamp "publish_date",                                                              precision: 6
    t.timestamp "forecast_date",                                                             precision: 6
    t.float     "pm25"
    t.float     "pm10"
    t.float     "SO2"
    t.float     "CO"
    t.float     "NO2"
    t.float     "O3"
    t.float     "AQI"
    t.float     "VIS"
    t.timestamp "created_at",                                                                precision: 6
    t.timestamp "updated_at",                                                                precision: 6
    t.spatial   "latlon",        limit: {:srid=>4326, :type=>"geometry", :geographic=>true}
    t.float     "longitude"
    t.float     "latitude"
  end

  create_table "forecast_real_data", force: true do |t|
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
    t.float    "ps"
    t.float    "tg"
    t.float    "rc"
    t.float    "rn"
    t.float    "ttp"
    t.float    "ter"
    t.float    "xmf"
    t.float    "dmf"
    t.float    "cor"
    t.float    "xlat"
    t.float    "xlon"
    t.float    "lu"
    t.float    "pbln"
    t.float    "pblr"
    t.float    "shf"
    t.float    "lhf"
    t.float    "ust"
    t.float    "swd"
    t.float    "lwd"
    t.float    "swo"
    t.float    "lwo"
    t.float    "t2m"
    t.float    "q2m"
    t.float    "u10"
    t.float    "v10"
    t.float    "wd"
    t.float    "ws"
    t.float    "pslv"
    t.float    "pwat"
    t.float    "clfrlo"
    t.float    "clfrmi"
    t.float    "clfrhi"
  end

  add_index "forecast_real_data", ["city_id", "publish_datetime", "forecast_datetime"], :name => "index_real_forecast_aqi_city_pubtime_foretime", :unique => true

  create_table "hourly_city_forecast_air_qualities", force: true do |t|
    t.integer   "city_id"
    t.timestamp "publish_datetime",  precision: 6
    t.timestamp "forecast_datetime", precision: 6
    t.float     "AQI"
    t.string    "main_pol"
    t.integer   "grade"
    t.float     "pm25"
    t.float     "pm10"
    t.float     "SO2"
    t.float     "CO"
    t.float     "NO2"
    t.float     "O3"
    t.float     "VIS"
    t.timestamp "created_at",        precision: 6
    t.timestamp "updated_at",        precision: 6
    t.float     "ps"
    t.float     "tg"
    t.float     "rc"
    t.float     "rn"
    t.float     "ttp"
    t.float     "ter"
    t.float     "xmf"
    t.float     "dmf"
    t.float     "cor"
    t.float     "xlat"
    t.float     "xlon"
    t.float     "lu"
    t.float     "pbln"
    t.float     "pblr"
    t.float     "shf"
    t.float     "lhf"
    t.float     "ust"
    t.float     "swd"
    t.float     "lwd"
    t.float     "swo"
    t.float     "lwo"
    t.float     "t2m"
    t.float     "q2m"
    t.float     "u10"
    t.float     "v10"
    t.float     "wd"
    t.float     "ws"
    t.float     "pslv"
    t.float     "pwat"
    t.float     "clfrlo"
    t.float     "clfrmi"
    t.float     "clfrhi"
  end

  add_index "hourly_city_forecast_air_qualities", ["city_id", "publish_datetime", "forecast_datetime"], :name => "index_hourlyaqi_city_pubtime_foretime", :unique => true

  create_table "locations", force: true do |t|
    t.string    "name"
    t.spatial   "latlon",     limit: {:srid=>4326, :type=>"geometry", :geographic=>true}
    t.timestamp "created_at",                                                             precision: 6
    t.timestamp "updated_at",                                                             precision: 6
  end

  create_table "monitor_point_days", force: true do |t|
    t.integer  "monitor_point_id"
    t.float    "SO2"
    t.float    "NO2"
    t.float    "CO"
    t.float    "O3"
    t.float    "O3_8h"
    t.float    "pm10"
    t.float    "pm25"
    t.float    "AQI"
    t.string   "level"
    t.string   "main_pol"
    t.string   "quality"
    t.float    "SO2_change_rate"
    t.float    "NO2_change_rate"
    t.float    "CO_change_rate"
    t.float    "O3_change_rate"
    t.float    "O3_8h_change_rate"
    t.float    "pm10_change_rate"
    t.float    "pm25_change_rate"
    t.float    "zongheindex_change_rate"
    t.string   "weather"
    t.string   "temp"
    t.string   "humi"
    t.string   "winddirection"
    t.string   "windspeed"
    t.integer  "windscale"
    t.float    "zonghezhishu"
    t.datetime "data_real_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "city_id"
    t.integer  "rank"
  end

  create_table "monitor_point_hours", force: true do |t|
    t.integer  "monitor_point_id"
    t.float    "SO2"
    t.float    "NO2"
    t.float    "CO"
    t.float    "O3"
    t.float    "pm10"
    t.float    "pm25"
    t.float    "AQI"
    t.string   "level"
    t.string   "main_pol"
    t.string   "quality"
    t.string   "weather"
    t.string   "temp"
    t.string   "humi"
    t.string   "winddirection"
    t.string   "windspeed"
    t.integer  "windscale"
    t.float    "zonghezhishu"
    t.datetime "data_real_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "O3_8h"
    t.integer  "city_id"
    t.integer  "rank"
  end

  create_table "monitor_point_months", force: true do |t|
    t.integer  "monitor_point_id"
    t.float    "SO2"
    t.float    "NO2"
    t.float    "CO"
    t.float    "O3"
    t.float    "O3_8h"
    t.float    "pm10"
    t.float    "pm25"
    t.float    "AQI"
    t.string   "level"
    t.string   "main_pol"
    t.string   "quality"
    t.float    "SO2_change_rate"
    t.float    "NO2_change_rate"
    t.float    "CO_change_rate"
    t.float    "O3_change_rate"
    t.float    "O3_8h_change_rate"
    t.float    "pm10_change_rate"
    t.float    "pm25_change_rate"
    t.float    "zongheindex_change_rate"
    t.string   "weather"
    t.string   "temp"
    t.string   "humi"
    t.string   "winddirection"
    t.string   "windspeed"
    t.integer  "windscale"
    t.float    "zonghezhishu"
    t.datetime "data_real_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "city_id"
    t.integer  "rank"
  end

  create_table "monitor_point_years", force: true do |t|
    t.integer  "monitor_point_id"
    t.float    "SO2"
    t.float    "NO2"
    t.float    "CO"
    t.float    "O3"
    t.float    "O3_8h"
    t.float    "pm10"
    t.float    "pm25"
    t.float    "AQI"
    t.string   "level"
    t.string   "main_pol"
    t.string   "quality"
    t.float    "SO2_change_rate"
    t.float    "NO2_change_rate"
    t.float    "CO_change_rate"
    t.float    "O3_change_rate"
    t.float    "O3_8h_change_rate"
    t.float    "pm10_change_rate"
    t.float    "pm25_change_rate"
    t.float    "zongheindex_change_rate"
    t.string   "weather"
    t.string   "temp"
    t.string   "humi"
    t.string   "winddirection"
    t.string   "windspeed"
    t.integer  "windscale"
    t.float    "zonghezhishu"
    t.datetime "data_real_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "city_id"
    t.integer  "rank"
  end

  create_table "monitor_points", force: true do |t|
    t.string    "region"
    t.string    "pointname"
    t.string    "level"
    t.float     "latitude"
    t.float     "longitude"
    t.timestamp "created_at", precision: 6
    t.timestamp "updated_at", precision: 6
    t.integer   "city_id"
  end

  add_index "monitor_points", ["pointname", "city_id"], :name => "index_monitor_points_on_pointname_and_city_id"

  create_table "regions", force: true do |t|
    t.string   "name"
    t.float    "area"
    t.float    "perimeter"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.spatial  "boundary",   limit: {:srid=>3857, :type=>"multi_polygon"}
  end

  add_index "regions", ["boundary"], :name => "index_regions_on_boundary", :spatial => true

  create_table "sources", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "station_dailies", force: true do |t|
    t.integer  "station_id"
    t.date     "publish_time"
    t.float    "pm25"
    t.float    "pm10"
    t.float    "o3"
    t.float    "o3_8h"
    t.float    "co"
    t.float    "so2"
    t.float    "no2"
    t.float    "aqi"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "station_dailies", ["station_id"], :name => "index_station_dailies_on_station_id"

  create_table "station_hours", force: true do |t|
    t.integer  "station_id"
    t.float    "pm25"
    t.float    "pm10"
    t.float    "o3"
    t.float    "o3_8h"
    t.float    "co"
    t.float    "so2"
    t.float    "no2"
    t.float    "aqi"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "station_hours", ["station_id"], :name => "index_station_hours_on_station_id"

  create_table "temp_bd_days", force: true do |t|
    t.integer   "city_id"
    t.float     "SO2"
    t.float     "NO2"
    t.float     "CO"
    t.float     "O3"
    t.float     "pm10"
    t.float     "pm25"
    t.float     "zonghezhishu"
    t.float     "AQI"
    t.string    "level"
    t.string    "main_pol"
    t.float     "SO2_change_rate"
    t.float     "NO2_change_rate"
    t.float     "CO_change_rate"
    t.float     "O3_change_rate"
    t.float     "pm10_change_rate"
    t.float     "pm25_change_rate"
    t.float     "zongheindex_change_rate"
    t.timestamp "data_real_time",          precision: 6
    t.string    "weather"
    t.integer   "temp"
    t.integer   "humi"
    t.string    "winddirection"
    t.integer   "windspeed"
    t.integer   "windscale"
    t.timestamp "created_at",              precision: 6
    t.timestamp "updated_at",              precision: 6
    t.integer   "rank"
  end

  create_table "temp_bd_hours", force: true do |t|
    t.integer   "city_id"
    t.float     "SO2"
    t.float     "NO2"
    t.float     "CO"
    t.float     "O3"
    t.float     "pm10"
    t.float     "pm25"
    t.float     "AQI"
    t.string    "level"
    t.string    "main_pol"
    t.string    "weather"
    t.string    "winddirection"
    t.timestamp "data_real_time", precision: 6
    t.float     "zonghezhishu"
    t.integer   "windscale"
    t.integer   "windspeed"
    t.integer   "humi"
    t.integer   "temp"
    t.timestamp "created_at",     precision: 6
    t.timestamp "updated_at",     precision: 6
    t.integer   "rank"
  end

  create_table "temp_bd_months", force: true do |t|
    t.integer   "city_id"
    t.float     "SO2"
    t.float     "NO2"
    t.float     "CO"
    t.float     "O3"
    t.float     "pm10"
    t.float     "pm25"
    t.float     "zonghezhishu"
    t.float     "AQI"
    t.string    "level"
    t.string    "main_pol"
    t.float     "SO2_change_rate"
    t.float     "NO2_change_rate"
    t.float     "CO_change_rate"
    t.float     "O3_change_rate"
    t.float     "pm10_change_rate"
    t.float     "pm25_change_rate"
    t.float     "zongheindex_change_rate"
    t.timestamp "data_real_time",          precision: 6
    t.timestamp "created_at",              precision: 6
    t.timestamp "updated_at",              precision: 6
    t.integer   "rank"
  end

  create_table "temp_bd_years", force: true do |t|
    t.integer   "city_id"
    t.float     "SO2"
    t.float     "NO2"
    t.float     "CO"
    t.float     "O3"
    t.float     "pm10"
    t.float     "pm25"
    t.float     "zonghezhishu"
    t.float     "AQI"
    t.string    "level"
    t.string    "main_pol"
    t.float     "SO2_change_rate"
    t.float     "NO2_change_rate"
    t.float     "CO_change_rate"
    t.float     "O3_change_rate"
    t.float     "pm10_change_rate"
    t.float     "pm25_change_rate"
    t.float     "zongheindex_change_rate"
    t.timestamp "data_real_time",          precision: 6
    t.timestamp "created_at",              precision: 6
    t.timestamp "updated_at",              precision: 6
    t.integer   "rank"
  end

  create_table "temp_hb_hours", force: true do |t|
    t.integer   "city_id"
    t.float     "SO2"
    t.float     "NO2"
    t.float     "CO"
    t.float     "O3"
    t.float     "pm10"
    t.float     "pm25"
    t.float     "AQI"
    t.string    "level"
    t.string    "main_pol"
    t.string    "weather"
    t.string    "winddirection"
    t.timestamp "data_real_time", precision: 6
    t.timestamp "created_at",     precision: 6
    t.timestamp "updated_at",     precision: 6
    t.float     "zonghezhishu"
    t.integer   "windscale"
    t.integer   "windspeed"
    t.integer   "humi"
    t.integer   "temp"
    t.integer   "rank"
  end

  create_table "temp_hourly_forecasts", force: true do |t|
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

  create_table "temp_jjj_days", force: true do |t|
    t.integer   "city_id"
    t.float     "SO2"
    t.float     "NO2"
    t.float     "CO"
    t.float     "O3"
    t.float     "pm10"
    t.float     "pm25"
    t.float     "zonghezhishu"
    t.float     "AQI"
    t.string    "level"
    t.string    "main_pol"
    t.float     "SO2_change_rate"
    t.float     "NO2_change_rate"
    t.float     "CO_change_rate"
    t.float     "O3_change_rate"
    t.float     "pm10_change_rate"
    t.float     "pm25_change_rate"
    t.float     "zongheindex_change_rate"
    t.timestamp "created_at",              precision: 6
    t.timestamp "updated_at",              precision: 6
    t.timestamp "data_real_time",          precision: 6
    t.string    "weather"
    t.integer   "temp"
    t.integer   "humi"
    t.string    "winddirection"
    t.integer   "windspeed"
    t.integer   "windscale"
    t.integer   "rank"
  end

  create_table "temp_jjj_months", force: true do |t|
    t.integer   "city_id"
    t.float     "SO2"
    t.float     "NO2"
    t.float     "CO"
    t.float     "O3"
    t.float     "pm10"
    t.float     "pm25"
    t.float     "zonghezhishu"
    t.float     "AQI"
    t.string    "level"
    t.string    "main_pol"
    t.float     "SO2_change_rate"
    t.float     "NO2_change_rate"
    t.float     "CO_change_rate"
    t.float     "O3_change_rate"
    t.float     "pm10_change_rate"
    t.float     "pm25_change_rate"
    t.float     "zongheindex_change_rate"
    t.timestamp "created_at",              precision: 6
    t.timestamp "updated_at",              precision: 6
    t.timestamp "data_real_time",          precision: 6
    t.integer   "maxindex"
    t.integer   "rank"
  end

  create_table "temp_jjj_years", force: true do |t|
    t.integer   "city_id"
    t.float     "SO2"
    t.float     "NO2"
    t.float     "CO"
    t.float     "O3"
    t.float     "pm10"
    t.float     "pm25"
    t.float     "zonghezhishu"
    t.float     "AQI"
    t.string    "level"
    t.string    "main_pol"
    t.float     "SO2_change_rate"
    t.float     "NO2_change_rate"
    t.float     "CO_change_rate"
    t.float     "O3_change_rate"
    t.float     "pm10_change_rate"
    t.float     "pm25_change_rate"
    t.float     "zongheindex_change_rate"
    t.timestamp "created_at",              precision: 6
    t.timestamp "updated_at",              precision: 6
    t.timestamp "data_real_time",          precision: 6
    t.integer   "maxindex"
    t.integer   "rank"
  end

  create_table "temp_lf_days", force: true do |t|
    t.integer   "city_id"
    t.float     "SO2"
    t.float     "NO2"
    t.float     "CO"
    t.float     "O3"
    t.float     "pm10"
    t.float     "pm25"
    t.float     "zonghezhishu"
    t.float     "AQI"
    t.string    "level"
    t.string    "main_pol"
    t.float     "SO2_change_rate"
    t.float     "NO2_change_rate"
    t.float     "CO_change_rate"
    t.float     "O3_change_rate"
    t.float     "pm10_change_rate"
    t.float     "pm25_change_rate"
    t.float     "zongheindex_change_rate"
    t.timestamp "created_at",              precision: 6
    t.timestamp "updated_at",              precision: 6
    t.timestamp "data_real_time",          precision: 6
    t.string    "weather"
    t.integer   "temp"
    t.integer   "humi"
    t.string    "winddirection"
    t.integer   "windspeed"
    t.integer   "windscale"
    t.integer   "rank"
  end

  create_table "temp_lf_hours", force: true do |t|
    t.integer   "city_id"
    t.float     "SO2"
    t.float     "NO2"
    t.float     "CO"
    t.float     "O3"
    t.float     "pm10"
    t.float     "pm25"
    t.float     "AQI"
    t.string    "level"
    t.string    "main_pol"
    t.string    "weather"
    t.string    "winddirection"
    t.timestamp "data_real_time", precision: 6
    t.timestamp "created_at",     precision: 6
    t.timestamp "updated_at",     precision: 6
    t.float     "zonghezhishu"
    t.integer   "windscale"
    t.integer   "windspeed"
    t.integer   "humi"
    t.integer   "temp"
    t.integer   "rank"
  end

  create_table "temp_lf_months", force: true do |t|
    t.integer   "city_id"
    t.float     "SO2"
    t.float     "NO2"
    t.float     "CO"
    t.float     "O3"
    t.float     "pm10"
    t.float     "pm25"
    t.float     "zonghezhishu"
    t.float     "AQI"
    t.string    "level"
    t.string    "main_pol"
    t.float     "SO2_change_rate"
    t.float     "NO2_change_rate"
    t.float     "CO_change_rate"
    t.float     "O3_change_rate"
    t.float     "pm10_change_rate"
    t.float     "pm25_change_rate"
    t.float     "zongheindex_change_rate"
    t.timestamp "created_at",              precision: 6
    t.timestamp "updated_at",              precision: 6
    t.timestamp "data_real_time",          precision: 6
    t.integer   "rank"
  end

  create_table "temp_lf_years", force: true do |t|
    t.integer   "city_id"
    t.float     "SO2"
    t.float     "NO2"
    t.float     "CO"
    t.float     "O3"
    t.float     "pm10"
    t.float     "pm25"
    t.float     "zonghezhishu"
    t.float     "AQI"
    t.string    "level"
    t.string    "main_pol"
    t.float     "SO2_change_rate"
    t.float     "NO2_change_rate"
    t.float     "CO_change_rate"
    t.float     "O3_change_rate"
    t.float     "pm10_change_rate"
    t.float     "pm25_change_rate"
    t.float     "zongheindex_change_rate"
    t.timestamp "created_at",              precision: 6
    t.timestamp "updated_at",              precision: 6
    t.timestamp "data_real_time",          precision: 6
    t.integer   "rank"
  end

  create_table "temp_sfcities_days", force: true do |t|
    t.integer   "city_id"
    t.float     "SO2"
    t.float     "NO2"
    t.float     "CO"
    t.float     "O3"
    t.float     "pm10"
    t.float     "pm25"
    t.float     "zonghezhishu"
    t.float     "AQI"
    t.string    "level"
    t.string    "main_pol"
    t.float     "SO2_change_rate"
    t.float     "NO2_change_rate"
    t.float     "CO_change_rate"
    t.float     "O3_change_rate"
    t.float     "pm10_change_rate"
    t.float     "pm25_change_rate"
    t.float     "zongheindex_change_rate"
    t.timestamp "created_at",              precision: 6
    t.timestamp "updated_at",              precision: 6
    t.timestamp "data_real_time",          precision: 6
    t.string    "weather"
    t.integer   "temp"
    t.integer   "humi"
    t.string    "winddirection"
    t.integer   "windspeed"
    t.integer   "windscale"
    t.integer   "rank"
  end

  create_table "temp_sfcities_hours", force: true do |t|
    t.integer   "city_id"
    t.float     "SO2"
    t.float     "NO2"
    t.float     "CO"
    t.float     "O3"
    t.float     "pm10"
    t.float     "pm25"
    t.float     "AQI"
    t.string    "level"
    t.string    "main_pol"
    t.string    "weather"
    t.string    "winddirection"
    t.timestamp "data_real_time", precision: 6
    t.timestamp "created_at",     precision: 6
    t.timestamp "updated_at",     precision: 6
    t.float     "zonghezhishu"
    t.integer   "windscale"
    t.integer   "windspeed"
    t.integer   "humi"
    t.integer   "temp"
    t.integer   "rank"
  end

  create_table "temp_sfcities_months", force: true do |t|
    t.integer   "city_id"
    t.float     "SO2"
    t.float     "NO2"
    t.float     "CO"
    t.float     "O3"
    t.float     "pm10"
    t.float     "pm25"
    t.float     "zonghezhishu"
    t.float     "AQI"
    t.string    "level"
    t.string    "main_pol"
    t.float     "SO2_change_rate"
    t.float     "NO2_change_rate"
    t.float     "CO_change_rate"
    t.float     "O3_change_rate"
    t.float     "pm10_change_rate"
    t.float     "pm25_change_rate"
    t.float     "zongheindex_change_rate"
    t.timestamp "created_at",              precision: 6
    t.timestamp "updated_at",              precision: 6
    t.timestamp "data_real_time",          precision: 6
    t.integer   "maxindex"
    t.integer   "rank"
  end

  create_table "temp_sfcities_years", force: true do |t|
    t.integer   "city_id"
    t.float     "SO2"
    t.float     "NO2"
    t.float     "CO"
    t.float     "O3"
    t.float     "pm10"
    t.float     "pm25"
    t.float     "zonghezhishu"
    t.float     "AQI"
    t.string    "level"
    t.string    "main_pol"
    t.float     "SO2_change_rate"
    t.float     "NO2_change_rate"
    t.float     "CO_change_rate"
    t.float     "O3_change_rate"
    t.float     "pm10_change_rate"
    t.float     "pm25_change_rate"
    t.float     "zongheindex_change_rate"
    t.timestamp "created_at",              precision: 6
    t.timestamp "updated_at",              precision: 6
    t.timestamp "data_real_time",          precision: 6
    t.integer   "maxindex"
    t.integer   "rank"
  end

  create_table "weather_days", force: true do |t|
    t.integer  "city_id"
    t.datetime "publish_datetime"
    t.string   "high"
    t.string   "low"
    t.string   "day_type"
    t.string   "day_fx"
    t.string   "day_fl"
    t.string   "night_type"
    t.string   "night_fx"
    t.string   "night_fl"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "weather_forecasts", force: true do |t|
    t.integer  "city_id"
    t.datetime "publish_datetime"
    t.datetime "forecast_datetime"
    t.string   "high"
    t.string   "low"
    t.string   "day_type"
    t.string   "day_fx"
    t.string   "day_fl"
    t.string   "night_type"
    t.string   "night_fx"
    t.string   "night_fl"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "weather_hours", force: true do |t|
    t.integer  "city_id"
    t.datetime "publish_datetime"
    t.integer  "wendu"
    t.string   "fengli"
    t.string   "shidu"
    t.string   "fengxiang"
    t.datetime "sunrise"
    t.datetime "sunset"
    t.text     "zhishu"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
