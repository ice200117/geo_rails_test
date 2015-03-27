class ForecastPointsController < ApplicationController
  before_action :set_forecast_point, only: [:show, :edit, :update, :destroy]


  # GET /forecast_points
  # GET /forecast_points.json
  def index
    #@forecast_points = ForecastPoint.all
    @forecast_points = ForecastPoint.all.paginate(:page => params[:page], :per_page => 5)

  end

  # GET /forecast_points/1
  # GET /forecast_points/1.json
  def show
  end

  # GET /forecast_points/new
  def new
    @forecast_point = ForecastPoint.new
  end

  # GET /forecast_points/1/edit
  def edit
  end

  # POST /forecast_points
  # POST /forecast_points.json
  def create
    @forecast_point = ForecastPoint.new(forecast_point_params)

    respond_to do |format|
      if @forecast_point.save
        format.html { redirect_to @forecast_point, notice: 'Forecast point was successfully created.' }
        format.json { render :show, status: :created, location: @forecast_point }
      else
        format.html { render :new }
        format.json { render json: @forecast_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /forecast_points/1
  # PATCH/PUT /forecast_points/1.json
  def update
    respond_to do |format|
      if @forecast_point.update(forecast_point_params)
        format.html { redirect_to @forecast_point, notice: 'Forecast point was successfully updated.' }
        format.json { render :show, status: :ok, location: @forecast_point }
      else
        format.html { render :edit }
        format.json { render json: @forecast_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forecast_points/1
  # DELETE /forecast_points/1.json
  def destroy
    @forecast_point.destroy
    respond_to do |format|
      format.html { redirect_to forecast_points_url, notice: 'Forecast point was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def lookup
    #lat = params[:lat].to_f
    #lon = params[:lon].to_f
    date = params[:publish_date]
    fpc = ForecastPoint.new
    o = fpc.lookup(date)
    render(:json => o)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_forecast_point
    @forecast_point = ForecastPoint.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def forecast_point_params
    params.require(:forecast_point).permit(:longitude, :latitude, :publish_date, :forecast_date, :pm25, :pm10, :SO2, :CO, :NO2, :O3, :AQI, :VIS)
  end

end
