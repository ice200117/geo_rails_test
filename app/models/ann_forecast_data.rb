class AnnForecastData < ActiveRecord::Base
  belongs_to :city

  ## city : single obj query from city table
  #  start_time : data of starttime
  #  datascope : 0 contain all 24 hour data, 48 hour data, 72 hour data, 96 hour data.
  #              1 contain 24 hour data
  #              2 contain 48 hour data
  #              3 contain 72 hour data
  #              4 contain 96 hour data
  def self.history_data_hour(city=City.find(18), start_time=3.days.ago, data_scope=0)
    fore_data_24 = []
    fore_data_48 = []
    fore_data_72 = []
    fore_data_96 = []
    data =  city.ann_forecast_data.where(publish_datetime: start_time..Time.now).order(:publish_datetime)
    
    data.each do |d|
      if d.forecast_datetime >= d.publish_datetime+12.hours and d.forecast_datetime < d.publish_datetime+36.hours
        fore_data_24 << [d.forecast_datetime, d.AQI]
      elsif d.forecast_datetime >= d.publish_datetime+36.hours and d.forecast_datetime < d.publish_datetime+60.hours
        fore_data_48 << [d.forecast_datetime, d.AQI]
      elsif d.forecast_datetime >= d.publish_datetime+60.hours and d.forecast_datetime < d.publish_datetime+84.hours
        fore_data_72 << [d.forecast_datetime, d.AQI]
      elsif d.forecast_datetime >= d.publish_datetime+84.hours and d.forecast_datetime < d.publish_datetime+108.hours
        fore_data_96 << [d.forecast_datetime, d.AQI]
      end
    end

    fore_data = []
    case data_scope
    when 0
      fore_data << fore_data_24
      fore_data << fore_data_48
      fore_data << fore_data_72
      fore_data << fore_data_96
    when 1
      fore_data_24
    when 2
      fore_data_48
    when 3
      fore_data_72
    when 4
      fore_data_96
    else
      fore_data
    end
  end
end
