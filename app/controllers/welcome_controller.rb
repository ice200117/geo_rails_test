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
        cs = City.all
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
    @chart = [{name: c.city_name, data: hs.map { |h| [ h.forecast_datetime.strftime("%H\n %d%b"),  h.AQI]} }]
    #@chart = c.hourly_city_forecast_air_qualities.group_by_hour(:forecast_datetime).average("AQI")
    respond_to do |format|
      format.html { }
      format.js   { }
      format.json {
        render json: @chart
      }
    end
  end

  def pinggu
    @post = params[:city_post] if params[:city_post]
    puts @post if @post 
    @county_data = [{title:'安次区',aqi:191,yesterday_aqi:179,r_rank:1,yesterday_r_rank:2}, 
    {title:'广阳区', aqi:182,yesterday_aqi:186,r_rank:2,yesterday_r_rank:1}, 
    {title:'廊坊开发区', aqi:140,yesterday_aqi:177,r_rank:3,yesterday_r_rank:3}, 
    {title:'固安县', aqi:134,yesterday_aqi:151,r_rank:4,yesterday_r_rank:6}, 
    {title:'永清县', aqi:112,yesterday_aqi:136,r_rank:5,yesterday_r_rank:7}, 
    {title:'香河县', aqi:110,yesterday_aqi:168,r_rank:6,yesterday_r_rank:4}, 
    {title:'大城县', aqi:101,yesterday_aqi:97,r_rank:7,yesterday_r_rank:10}, 
    {title:'文安县', aqi:97,yesterday_aqi:119,r_rank:8,yesterday_r_rank:9}, 
    {title:'大厂', aqi:96,yesterday_aqi:132,r_rank:9,yesterday_r_rank:8}, 
    {title:'霸州市', aqi:92,yesterday_aqi:92,r_rank:10,yesterday_r_rank:11}, 
    {title:'三河市', aqi:91,yesterday_aqi:160,r_rank:11,yesterday_r_rank:5}]

    @post = '131000' unless @post
  end
end

