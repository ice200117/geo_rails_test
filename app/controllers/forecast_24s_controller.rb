class Forecast24sController < ApplicationController
  before_action :set_forecast_24, only: [:show, :edit, :update, :destroy]

  # GET /forecast_24s
  # GET /forecast_24s.json
  def index
    @forecast_24s = Forecast24.all
  end

  # GET /forecast_24s/1
  # GET /forecast_24s/1.json
  def show
  end

  # GET /forecast_24s/new
  def new
    @forecast_24 = Forecast24.new
  end

  # GET /forecast_24s/1/edit
  def edit
  end

  # POST /forecast_24s
  # POST /forecast_24s.json
  def create
    @forecast_24 = Forecast24.new(forecast_24_params)

    respond_to do |format|
      if @forecast_24.save
        format.html { redirect_to @forecast_24, notice: 'Forecast 24 was successfully created.' }
        format.json { render :show, status: :created, location: @forecast_24 }
      else
        format.html { render :new }
        format.json { render json: @forecast_24.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /forecast_24s/1
  # PATCH/PUT /forecast_24s/1.json
  def update
    respond_to do |format|
      if @forecast_24.update(forecast_24_params)
        format.html { redirect_to @forecast_24, notice: 'Forecast 24 was successfully updated.' }
        format.json { render :show, status: :ok, location: @forecast_24 }
      else
        format.html { render :edit }
        format.json { render json: @forecast_24.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forecast_24s/1
  # DELETE /forecast_24s/1.json
  def destroy
    @forecast_24.destroy
    respond_to do |format|
      format.html { redirect_to forecast_24s_url, notice: 'Forecast 24 was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_forecast_24
      @forecast_24 = Forecast24.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def forecast_24_params
      params.require(:forecast_24).permit(:station_id_id, :pattern, :publish_time, :predict_time, :pm25, :pm10, :o3, :o3_8h, :co, :so2, :no2, :aqi)
    end
end
