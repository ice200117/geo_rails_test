require_relative '../replace_temp_table_from_hourly.rb'
stime = Time.now.beginning_of_hour
etime = Time.now.end_of_hour
replace_eight_hours(stime,etime)
system('curl http://www.izhenqi.cn/crawler/aqi_forecast_city_jjj.php')
