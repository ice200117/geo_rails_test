class Forecast72sController < ApplicationController
  before_action :set_forecast_72, only: [:show, :edit, :update, :destroy]

  # GET /forecast_72s
  # GET /forecast_72s.json
  def index
    @forecast_72s = Forecast72.all
  end

  # GET /forecast_72s/1
  # GET /forecast_72s/1.json
  def show
  end

  # GET /forecast_72s/new
  def new
    @forecast_72 = Forecast72.new
  end

  # GET /forecast_72s/1/edit
  def edit
  end

  # POST /forecast_72s
  # POST /forecast_72s.json
  def create
    @forecast_72 = Forecast72.new(forecast_72_params)

    respond_to do |format|
      if @forecast_72.save
        format.html { redirect_to @forecast_72, notice: 'Forecast 72 was successfully created.' }
        format.json { render :show, status: :created, location: @forecast_72 }
      else
        format.html { render :new }
        format.json { render json: @forecast_72.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /forecast_72s/1
  # PATCH/PUT /forecast_72s/1.json
  def update
    respond_to do |format|
      if @forecast_72.update(forecast_72_params)
        format.html { redirect_to @forecast_72, notice: 'Forecast 72 was successfully updated.' }
        format.json { render :show, status: :ok, location: @forecast_72 }
      else
        format.html { render :edit }
        format.json { render json: @forecast_72.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forecast_72s/1
  # DELETE /forecast_72s/1.json
  def destroy
    @forecast_72.destroy
    respond_to do |format|
      format.html { redirect_to forecast_72s_url, notice: 'Forecast 72 was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_forecast_72
      @forecast_72 = Forecast72.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def forecast_72_params
      params.require(:forecast_72).permit(:station_id_id, :pattern, :publish_time, :predict_time, :pm25, :pm10, :o3, :o3_8h, :co, :so2, :no2, :aqi)
    end
end
