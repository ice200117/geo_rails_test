
require "numru/netcdf"                           # load RubyNetCDF
#require 'sqlite3'
require 'pg'
include NumRu


def read_adj (ncfile, city_file, var_name)
  file = NetCDF.open(ncfile)
  

  # Get longitude
  var = file.var(var_name)
  data = var.get
  #puts data.shape
  
  x = Array.new
  y = Array.new
  #puts city_file
  lines = IO.readlines(city_file)
  num_points = lines.length - 1
  #lines.each { |line|
  for i in 1..lines.length-1
    as = lines[i].split(pattern=' ') 
    x << as[0].to_i - 1
    y << as[1].to_i - 1
  end
  #}

  sum_per = 0.0
  for i in 0..num_points-1
    #puts data[x[i],y[i],0,0]
    sum_per += data[x[i],y[i],0,0]
  end
  return sum_per
end

def cal_var ( ncfile, var_name )
  pl = Array.new
  CITY_LIST.each { |city_file|
    pl << (read_adj ncfile, city_file, var_name)
  }
  return pl
end

#path = "/vagrant/geo_rails_test/public/images/ftproot/Temp/ADJ/"
path = "/vagrant/geo_rails_test/public/images/ftproot/Temp/"
ncfile = path + "CUACE_09km_adj_2015-11-28.nc"
  CITY_LIST = [
  "MeteoInfo/baoding.txt",
  "MeteoInfo/beijing.txt",
  "MeteoInfo/cangzhou.txt",
  "MeteoInfo/chengde.txt",
  "MeteoInfo/handan.txt",
  "MeteoInfo/hengshui.txt",
  "MeteoInfo/langfang.txt",
  "MeteoInfo/qinhuangdao.txt",
  "MeteoInfo/shijiazhuang.txt",
  "MeteoInfo/tangshan.txt",
  "MeteoInfo/tianjin.txt",
  "MeteoInfo/xingtai.txt",
  "MeteoInfo/zhangjiakou.txt" ]
var_list = ["CO_120", "NOX_120", "SO2_120"]
var_list.each { |var_name|
  pl = (cal_var ncfile, var_name)
  puts var_name
  pl.sort.last(3).each { |p|
    print CITY_LIST[pl.index(p)], "   ", p, "\n"
  }
}



def read_daily ( ncfile, city_file )
  file = NetCDF.open(ncfile)

  # Get longitude
  vlon = file.var("lon")
  lon = vlon.get

  # Get latitude
  vlat = file.var("lat")
  lat = vlat.get

  # Get time
  vtime = file.var("time")
  time = vtime.get
  t =  Time.utc(1900,1,1,0)
  tb = t.to_i
  ttime = Array.new
  for i in 0..4
    ttime << Time.at(time[i]*60*60 + tb).getutc
    puts Time.at(time[i]*60*60 + tb).getutc
  end

  strvars = ["PM2_5", "PM10", "SO2", "CO", "NO2", "O3", "AQI", "VIS"]
  # Get AQI
  vars = file.vars(strvars)
  #var.each_att{ |a|
    #print a.name,"\n"
  #}
  #puts file.dim("time").name
  #puts var.ndims
  #for i in 0..2
    #puts var.dim(i).name
    #puts var.dim(i).length
  #end
  dataArr = Array.new
  vars.each { |var|
    data = var.get
    dataArr << data
  }
  #puts ary3d.shape
  #

  x = Array.new
  y = Array.new
  lines = IO.readlines(city_file)
  num_line = lines.length
  puts num_line
  lines.each { |line|
    as = line.split(pattern=' ') 
    x << as[0].to_i - 1
    y << as[1].to_i - 1
  }

  for i in 0..num_line-1
    puts dataArr[1][x[i],y[i],1]
  end


  # Open a database
  #db = SQLite3::Database.new "/home/lice/forecastAQI/db/development.sqlite3"
  db = PG::Connection.new(nil, 5432, nil, nil, 'forecastAQI_development', 'pguser', 'pguser')

  ## Create a database
  #rows = db.execute <<-SQL
    #create table numbers (
      #name varchar(30),
      #val int
    #);
  #SQL

  ## Execute a few inserts
  #{
    #"one" => 1,
    #"two" => 2,
  #}.each do |pair|
    #db.execute "insert into numbers values ( ?, ? )", pair
  #end

  ## Execute inserts with parameter markers
  #db.execute("INSERT INTO students (name, email, grade, blog) 
              #VALUES (?, ?, ?, ?)", [@name, @email, @grade, @blog])

  fpl = ForecastPoint.all
  fpl.each { |fp| fp.destroy }

  # Insert forecast points
  for j in 0..ttime.length-1
    for i in 0..num_line-1
      puts i
      fp = ForecastPoint.new
      fp.longitude      = lon[x[i]] 
      fp.latitude       = lat[y[i]] 
      fp.publish_date   = ttime[0]
      fp.forecast_date  = ttime[j]
      fp.pm25           = dataArr[0][x[i],y[i],j]
      fp.pm10           = dataArr[1][x[i],y[i],j]
      fp.SO2            = dataArr[2][x[i],y[i],j]
      fp.CO             = dataArr[3][x[i],y[i],j]
      fp.NO2            = dataArr[4][x[i],y[i],j]
      fp.O3             = dataArr[5][x[i],y[i],j]
      fp.AQI            = dataArr[6][x[i],y[i],j]
      fp.VIS            = dataArr[7][x[i],y[i],j]
      fp.save 
    end
  end

  # Find a few rows
  #db.execute( "select * from forecast_points" ) do |row|
  fps = ForecastPoint.all
  fps.each do |row|
    p row.longitude
  end
end

#ncfile = "/mnt/share/CUACE_09km_daily_2014-09-28.nc"
#city_file = "/mnt/share/langfang.txt"
#read_daily ncfile, city_file
