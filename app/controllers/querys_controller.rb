class QuerysController < ApplicationController
  include NumRu
  protect_from_forgery :except => :adj

  @@alt = true


  def adj_5days
    if params[:var]
      varnames = [params[:var]]
    else
      varnames = ["CO_120", "NOX_120", "SO2_120",
       "CO_96", "NOX_96", "SO2_96" , 
       "CO_72", "NOX_72", "SO2_72" , 
       "CO_48", "NOX_48", "SO2_48" ,
       "CO_24", "NOX_24", "SO2_24" ]
    end
    #puts varnames
	path = '/mnt/share/Temp/BackupADJ/'

    if params[:city_name]
		path = '/mnt/share/Temp/BackupADJ_baoding/'
	end
    #if @@alt
    #  @@alt = false
    #  puts 'langfang'
    #  path = '/mnt/share/Temp/BackupADJ/'
    #else
    #  @@alt = true
    #  puts 'baoding'
    #  path = '/mnt/share/Temp/BackupADJ_baoding/'
    #end
    nt = Time.now
    i = 0
    begin
      #puts i
      strtime = (nt-60*60*24*i).strftime("%Y-%m-%d")
      ncfile = path + 'CUACE_09km_adj_'+strtime+'.nc'
      i = i + 1
    end until File::exists?(ncfile)

    #puts ncfile
    file = NetCDF.open(ncfile)
    @dataArr = Hash.new
    varnames.each do |var|
      data = file.var(var).get
      @dataArr[var] = data[0..-1,0..-1,0,0].to_a
    end
    #render json: @dataArr.to_json
    ret_data = Hash.new
    ret_data[:time]= strtime 
    ret_data[:data]= @dataArr 
    respond_to do |format|
      format.html { render json: ret_data}
      if params[:callback]
        format.js { render :json => ret_data.to_json, :callback => params[:callback] }
      else
        format.json { render json: ret_data}
      end
    end

  end

  def adj
    if params[:var]
      varnames = [params[:var]]
    else
      varnames = ["CO_120", "NOX_120", "SO2_120"]
    end
    #puts varnames
    path = '/mnt/share/Temp/BackupADJ/'
    #if @@alt
    #  @@alt = false
    #  puts 'langfang'
    #  path = '/mnt/share/Temp/BackupADJ/'
    #else
    #  @@alt = true
    #  puts 'baoding'
    #  path = '/mnt/share/Temp/BackupADJ_baoding/'
    #end
    nt = Time.now
    i = 0
    begin
      #puts i
      strtime = (nt-60*60*24*i).strftime("%Y-%m-%d")
      ncfile = path + 'CUACE_09km_adj_'+strtime+'.nc'
      i = i + 1
    end until File::exists?(ncfile)

    #puts ncfile
    file = NetCDF.open(ncfile)
    @dataArr = Hash.new
    varnames.each do |var|
      data = file.var(var).get
      @dataArr[var] = data[0..-1,0..-1,0,0].to_a
    end
    #render json: @dataArr.to_json
    respond_to do |format|
      format.html { render json: @dataArr}
      if params[:callback]
        format.js { render :json => @dataArr.to_json, :callback => params[:callback] }
      else
        format.json { render json: @dataArr}
      end
    end

  end

  def aqis_by_city
    pinyin = params[:city]
    h = HourlyCityForecastAirQuality.new
    chf = h.city_forecast(pinyin)
    render json: chf
  end

  def cities
    cs = City.pluck(:city_name, :city_name_pinyin)
    render json: cs
  end

  def all_cities2
    achf = []
    ac = City.pluck(:city_name_pinyin)
    h = HourlyCityForecastAirQuality.new
    ac.each do |c|
      ch = h.city_forecast(c) 
      achf << ch if ch
    end

    render json: achf
  end

  def all_cities
    achf = []
    cs = City.includes(:hourly_city_forecast_air_qualities)
    cs.each do |c|
      cf = Hash.new
      hf = []
      #hs = c.hourly_city_forecast_air_qualities.order(publish_datetime: :desc).limit(120).where("forecast_datetime > ?", Time.now)
      hs = c.hourly_city_forecast_air_qualities.last(120)
      return nil unless hs.first
      cf[:city_name] = c.city_name
      cf[:publish_datetime] = hs.first.publish_datetime.strftime('%Y-%m-%d_%H')
#      cf[:update_time] = Time.now.strftime('%Y-%m-%d_%H')
      hs.each do |ch|
        if ch.forecast_datetime > Time.now
      #    ch.AQI = (ch.AQI**2 *0.0004 + 0.3314*ch.AQI - 32.231 ).round if c.city_name_pinyin=='taiyuanshi'
          hf << {forecast_datetime: ch.forecast_datetime.strftime('%Y-%m-%d_%H'), 
                 AQI: ch.AQI.round, 
                 main_pol: ch.main_pol, 
                 grade: ch.grade,
                 pm2_5: ch.pm25,
                 pm10: ch.pm10,
                 SO2: ch.SO2,
                 CO: ch.CO,
                 NO2: ch.NO2,
                 O3: ch.O3,
                 VIS: ch.VIS }
        end
      end
      cf[:forecast_data] = hf
      achf << cf
    end

    render json: achf
  end
end
