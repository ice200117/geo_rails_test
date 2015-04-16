class WelcomeController < ApplicationController
  def index

    #data_table = GoogleVisualr::DataTable.new
    #data_table.new_column('string', 'Country')
    #data_table.new_column('number', 'Popularity')
    #data_table.add_rows(6)
    #data_table.set_cell(0, 0, 'Germany')
    #data_table.set_cell(0, 1, 200)
    #data_table.set_cell(1, 0, 'United States')
    #data_table.set_cell(1, 1, 300)
    #data_table.set_cell(2, 0, 'Brazil')
    #data_table.set_cell(2, 1, 400)
    #data_table.set_cell(3, 0, 'Canada')
    #data_table.set_cell(3, 1, 500)
    #data_table.set_cell(4, 0, 'France')
    #data_table.set_cell(4, 1, 600)
    #data_table.set_cell(5, 0, 'RU')
    #data_table.set_cell(5, 1, 700)

    #opts   = { :width => 500, :height => 300 }
    #@chart = GoogleVisualr::Interactive::GeoChart.new(data_table, opts)

    #data_table_markers = GoogleVisualr::DataTable.new
    #data_table_markers.new_column('string'  , 'Country'   )
    #data_table_markers.new_column('number'  , 'Popularity')
    #data_table_markers.add_rows(6)
    #data_table_markers.set_cell(0, 0, 'New York'     )
    #data_table_markers.set_cell(0, 1, 200)
    #data_table_markers.set_cell(1, 0, 'Boston'       )
    #data_table_markers.set_cell(1, 1, 300)
    #data_table_markers.set_cell(2, 0, 'Miami'        )
    #data_table_markers.set_cell(2, 1, 400)
    #data_table_markers.set_cell(3, 0, 'Chicago'      )
    #data_table_markers.set_cell(3, 1, 500)
    #data_table_markers.set_cell(4, 0, 'Los Angeles'  )
    #data_table_markers.set_cell(4, 1, 600)
    #data_table_markers.set_cell(5, 0, 'Houston'      )
    #data_table_markers.set_cell(5, 1, 700)

    #opts   = {  :region => 'US'  }
    #@chart = GoogleVisualr::Interactive::GeoChart.new(data_table_markers, opts)


    #data_table = GoogleVisualr::DataTable.new
    #data_table.new_column('number', 'Lat' )
    #data_table.new_column('number', 'Lon' )
    #data_table.new_column('string', 'Name')
    #data_table.add_rows(4)
    #data_table.set_cell(0, 0, 37.4232   )
    #data_table.set_cell(0, 1, -122.0853 )
    #data_table.set_cell(0, 2, 'Work'      )
    #data_table.set_cell(1, 0, 37.4289   )
    #data_table.set_cell(1, 1, -122.1697 )
    #data_table.set_cell(1, 2, 'University')
    #data_table.set_cell(2, 0, 37.6153   )
    #data_table.set_cell(2, 1, -122.3900 )
    #data_table.set_cell(2, 2, 'Airport'   )
    #data_table.set_cell(3, 0, 37.4422   )
    #data_table.set_cell(3, 1, -122.1731 )
    #data_table.set_cell(3, 2, 'Shopping'  )

    #opts   = { :showTip => true }
    #@chart = GoogleVisualr::Interactive::Map.new(data_table, opts)
  end

  def show
    # @visits = Visit.all
  end

  def map

    respond_to do |format|
      format.js   {}
      format.html   {}
      format.json {
        achf = Hash.new
        cs = City.includes(:hourly_city_forecast_air_qualities)
        cs.each do |c|
          ch = c.hourly_city_forecast_air_qualities.last(120)[0]
          achf[c.city_name] = ch.AQI  if ch
        end
        render json: achf
      }
    end
  end

  def visits_by_day
    id =  params[:city_id]
    visits = Visit.all
    if id == "1"
      @chart = Visit.group_by_day(:visited_at, format: "%B %d, %Y").count
    else
      @chart = Visit.pluck("country").uniq.map { |c| { name: c, data: visits.where(country: c).group_by_day(:visited_at, format: "%B %d, %Y").count } }
    end
    respond_to do |format|
      format.js   {}
      format.json {
        render json: @chart
      }
    end
  end

  def bar
    params[:c] ? (id =  params[:c][:city_id]) : (id = City.find_by city_name_pinyin: 'langfangshi')
    c = City.find(id)
    if params[:start_date] && params[:end_date]
      sd = Time.local(params[:start_date][:year].to_i, params[:start_date][:month].to_i, params[:start_date][:day].to_i)
      ed = Time.local(params[:end_date][:year].to_i, params[:end_date][:month].to_i, params[:end_date][:day].to_i,23)
      return 'error: start date can not later than end date!' if sd > ed
      hss = c.hourly_city_forecast_air_qualities.last(120)
      hs = []
      hss.each {|h| hs << h if h.forecast_datetime >= sd && h.forecast_datetime <= ed }
    else
      hs = c.hourly_city_forecast_air_qualities.last(120)
    end
    #@chart = [{name: c.city_name, data: hs.group_by_hour(:forecast_datetime).average("AQI")}]
    @chart = [{name: c.city_name, data: hs.map { |h| [ h.forecast_datetime.strftime("%Y%m%d%H"),  h.AQI]} }]
    #@chart = c.hourly_city_forecast_air_qualities.group_by_hour(:forecast_datetime).average("AQI")
    respond_to do |format|
      format.js   { }
      format.html { }
      format.json {
        render json: @chart
      }
    end
  end
end

