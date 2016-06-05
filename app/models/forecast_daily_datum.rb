class ForecastDailyDatum < ActiveRecord::Base
	belongs_to :city

  default_scope { where city_id: 18 } # default Langfang 
  after_save do |f|
	  Custom::Redis.del('langfang_weather') 
  end

  def self.create_5obj(date = Date.today)
    pdate = date
    fdate = pdate
	edate = fdate + 5.days
    fs = ForecastDailyDatum.where(publish_date: pdate-1.day)
	max = nil
	min = nil
	main = '暂无数据'

    while fdate < edate
	  # Get yesterday forecast data.
	  fs.each do |f|
		  if f.forecast_date == fdate
			  max = f.max_forecast
			  min = f.min_forecast
			  main = f.main_pollutant
		  end
	  end

      ForecastDailyDatum.create(city_id: 18, publish_date: pdate, forecast_date: fdate, main_pollutant:main, max_forecast: max, min_forecast: min)
      fdate = fdate + 1.day
    end
  end

  def self.isModify(fs)
    fs.each do |f|
      if f.max_forecast != nil and f.min_forecast != nil
        return true
      end
    end
    false
  end


  def self.get_three_daily_range
    td = Date.today-1.day
    begin
      fs = ForecastDailyDatum.where(publish_date: td)
      break if fs.length>0 and isModify(fs)
      create_5obj(td) if fs.empty?
      td = td - 1.day
    end while td > 4.days.ago.to_date


    ret = {}
    fs.each do |f|
      next if f.forecast_date < Date.today
      ret[f.forecast_date] = {"min_forecast"=> f.min_forecast, "max_forecast"=> f.max_forecast, "main_pollutant"=> f.main_pollutant, "level"=> get_lev(f.min_forecast), "level1"=> get_lev(f.max_forecast)}
    end
    [ret, td]
  end

	#aqi等级
  def self.get_lev(a)
		if (0 .. 50) === a
			lev = '优'
		elsif (50 .. 100) === a
			lev = '良'
		elsif (100 .. 150) === a
			lev = '轻度污染'
		elsif (150 .. 200) === a
			lev = '中度污染'
		elsif (200 .. 300) === a
			lev = '重度污染'
		elsif (300 .. 500) === a
			lev = '严重污染'
		end
  end
end
