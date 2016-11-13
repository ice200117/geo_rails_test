require_relative './fix_forecast_by_least_square.rb'
require_relative '../replace_temp_table_from_hourly.rb'

fix_forecast_by_least_square()
stime = '2016111307'.to_time.beginning_of_hour
etime = Time.now.end_of_hour
replace_eight_hours(stime,etime)
# system('curl http://www.izhenqi.cn/crawler/aqi_forecast_city_jjj.php')

