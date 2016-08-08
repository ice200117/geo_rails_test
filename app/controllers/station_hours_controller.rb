class StationHoursController < ApplicationController
  before_action :set_station_hour, only: [:show, :edit, :update, :destroy]

  # GET /station_hours
  # GET /station_hours.json
  def index
    @station_hours = StationHour.all
  end

  # GET /station_hours/1
  # GET /station_hours/1.json
  def show
  end

  # GET /station_hours/new
  def new
    @station_hour = StationHour.new
  end

  # GET /station_hours/1/edit
  def edit
  end

  # POST /station_hours
  # POST /station_hours.json
  def create
    @station_hour = StationHour.new(station_hour_params)

    respond_to do |format|
      if @station_hour.save
        format.html { redirect_to @station_hour, notice: 'Station hour was successfully created.' }
        format.json { render :show, status: :created, location: @station_hour }
      else
        format.html { render :new }
        format.json { render json: @station_hour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /station_hours/1
  # PATCH/PUT /station_hours/1.json
  def update
    respond_to do |format|
      if @station_hour.update(station_hour_params)
        format.html { redirect_to @station_hour, notice: 'Station hour was successfully updated.' }
        format.json { render :show, status: :ok, location: @station_hour }
      else
        format.html { render :edit }
        format.json { render json: @station_hour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /station_hours/1
  # DELETE /station_hours/1.json
  def destroy
    @station_hour.destroy
    respond_to do |format|
      format.html { redirect_to station_hours_url, notice: 'Station hour was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_station_hour
      @station_hour = StationHour.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def station_hour_params
      params.require(:station_hour).permit(:station_id_id, :pm25, :pm10, :o3, :o3_8h, :co, :so2, :no2, :aqi)
    end
end
