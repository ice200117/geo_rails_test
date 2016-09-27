class Forecast96sController < ApplicationController
  before_action :set_forecast_96, only: [:show, :edit, :update, :destroy]

  # GET /forecast_96s
  # GET /forecast_96s.json
  def index
    @forecast_96s = Forecast96.all
  end

  # GET /forecast_96s/1
  # GET /forecast_96s/1.json
  def show
  end

  # GET /forecast_96s/new
  def new
    @forecast_96 = Forecast96.new
  end

  # GET /forecast_96s/1/edit
  def edit
  end

  # POST /forecast_96s
  # POST /forecast_96s.json
  def create
    @forecast_96 = Forecast96.new(forecast_96_params)

    respond_to do |format|
      if @forecast_96.save
        format.html { redirect_to @forecast_96, notice: 'Forecast 96 was successfully created.' }
        format.json { render :show, status: :created, location: @forecast_96 }
      else
        format.html { render :new }
        format.json { render json: @forecast_96.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /forecast_96s/1
  # PATCH/PUT /forecast_96s/1.json
  def update
    respond_to do |format|
      if @forecast_96.update(forecast_96_params)
        format.html { redirect_to @forecast_96, notice: 'Forecast 96 was successfully updated.' }
        format.json { render :show, status: :ok, location: @forecast_96 }
      else
        format.html { render :edit }
        format.json { render json: @forecast_96.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forecast_96s/1
  # DELETE /forecast_96s/1.json
  def destroy
    @forecast_96.destroy
    respond_to do |format|
      format.html { redirect_to forecast_96s_url, notice: 'Forecast 96 was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_forecast_96
      @forecast_96 = Forecast96.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def forecast_96_params
      params.require(:forecast_96).permit(:station_id_id, :pattern, :publish_time, :predict_time, :pm25, :pm10, :o3, :o3_8h, :co, :so2, :no2, :aqi)
    end
end
