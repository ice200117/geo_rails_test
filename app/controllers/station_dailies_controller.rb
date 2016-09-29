class StationDailiesController < ApplicationController
  before_action :set_station_daily, only: [:show, :edit, :update, :destroy]

  # GET /station_dailies
  # GET /station_dailies.json
  def index
    @station_dailies = StationDaily.all
  end

  # GET /station_dailies/1
  # GET /station_dailies/1.json
  def show
  end

  # GET /station_dailies/new
  def new
    @station_daily = StationDaily.new
  end

  # GET /station_dailies/1/edit
  def edit
  end

  # POST /station_dailies
  # POST /station_dailies.json
  def create
    @station_daily = StationDaily.new(station_daily_params)
    respond_to do |format|
      if @station_daily.save
        format.html { redirect_to @station_daily, notice: 'Station daily was successfully created.' }
        format.json { render :show, status: :created, location: @station_daily }
      else
        format.html { render :new }
        format.json { render json: @station_daily.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /station_dailies/1
  # PATCH/PUT /station_dailies/1.json
  def update
    respond_to do |format|
      if @station_daily.update(station_daily_params)
        format.html { redirect_to @station_daily, notice: 'Station daily was successfully updated.' }
        format.json { render :show, status: :ok, location: @station_daily }
      else
        format.html { render :edit }
        format.json { render json: @station_daily.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /station_dailies/1
  # DELETE /station_dailies/1.json
  def destroy
    @station_daily.destroy
    respond_to do |format|
      format.html { redirect_to station_dailies_url, notice: 'Station daily was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_station_daily
      @station_daily = StationDaily.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def station_daily_params
      params.require(:station_daily).permit(:station_id_id, :publish_time, :pm25, :pm10, :o3, :o3_8h, :co, :so2, :no2, :aqi)
    end
end
