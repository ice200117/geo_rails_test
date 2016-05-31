class ForecastDailyDatum < ActiveRecord::Base
	belongs_to :city

  default_scope { where city_id: 18 } # default Langfang 
  after_save do |f|
	  Custom::Redis.del('langfang_weather') 
  end


  def self.get_three_daily_range
    td = Date.today
    begin
      fs = ForecastDailyDatum.where(publish_date: td)
      break if fs.length>0
      td = td - 1.day
    end while td > 3.days.ago.to_date


    ret = {}
    fs.each do |f|
      next if f.forecast_date < Date.today
      ret[f.forecast_date] = {"min_forecast"=> f.min_forecast, "max_forecast"=> f.max_forecast, "main_pollutant"=> f.main_pollutant, "level"=> get_lev(f.min_forecast), "level1"=> get_lev(f.max_forecast)}
    end
    ret
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
