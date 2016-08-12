class Forecast48sController < ApplicationController
  before_action :set_forecast_48, only: [:show, :edit, :update, :destroy]

  # GET /forecast_48s
  # GET /forecast_48s.json
  def index
    @forecast_48s = Forecast48.all
  end

  # GET /forecast_48s/1
  # GET /forecast_48s/1.json
  def show
  end

  # GET /forecast_48s/new
  def new
    @forecast_48 = Forecast48.new
  end

  # GET /forecast_48s/1/edit
  def edit
  end

  # POST /forecast_48s
  # POST /forecast_48s.json
  def create
    @forecast_48 = Forecast48.new(forecast_48_params)

    respond_to do |format|
      if @forecast_48.save
        format.html { redirect_to @forecast_48, notice: 'Forecast 48 was successfully created.' }
        format.json { render :show, status: :created, location: @forecast_48 }
      else
        format.html { render :new }
        format.json { render json: @forecast_48.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /forecast_48s/1
  # PATCH/PUT /forecast_48s/1.json
  def update
    respond_to do |format|
      if @forecast_48.update(forecast_48_params)
        format.html { redirect_to @forecast_48, notice: 'Forecast 48 was successfully updated.' }
        format.json { render :show, status: :ok, location: @forecast_48 }
      else
        format.html { render :edit }
        format.json { render json: @forecast_48.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forecast_48s/1
  # DELETE /forecast_48s/1.json
  def destroy
    @forecast_48.destroy
    respond_to do |format|
      format.html { redirect_to forecast_48s_url, notice: 'Forecast 48 was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_forecast_48
      @forecast_48 = Forecast48.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def forecast_48_params
      params.require(:forecast_48).permit(:station_id_id, :pattern, :publish_time, :predict_time, :pm25, :pm10, :o3, :o3_8h, :co, :so2, :no2, :aqi)
    end
end
