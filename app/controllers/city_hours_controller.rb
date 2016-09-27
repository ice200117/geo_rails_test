class CityHoursController < ApplicationController
  before_action :set_city_hour, only: [:show, :edit, :update, :destroy]

  # GET /city_hours
  # GET /city_hours.json
  def index
    @city_hours = CityHour.all
  end

  # GET /city_hours/1
  # GET /city_hours/1.json
  def show
  end

  # GET /city_hours/new
  def new
    @city_hour = CityHour.new
  end

  # GET /city_hours/1/edit
  def edit
  end

  # POST /city_hours
  # POST /city_hours.json
  def create
    @city_hour = CityHour.new(city_hour_params)

    respond_to do |format|
      if @city_hour.save
        format.html { redirect_to @city_hour, notice: 'City hour was successfully created.' }
        format.json { render :show, status: :created, location: @city_hour }
      else
        format.html { render :new }
        format.json { render json: @city_hour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /city_hours/1
  # PATCH/PUT /city_hours/1.json
  def update
    respond_to do |format|
      if @city_hour.update(city_hour_params)
        format.html { redirect_to @city_hour, notice: 'City hour was successfully updated.' }
        format.json { render :show, status: :ok, location: @city_hour }
      else
        format.html { render :edit }
        format.json { render json: @city_hour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /city_hours/1
  # DELETE /city_hours/1.json
  def destroy
    @city_hour.destroy
    respond_to do |format|
      format.html { redirect_to city_hours_url, notice: 'City hour was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_city_hour
      @city_hour = CityHour.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def city_hour_params
      params.require(:city_hour).permit(:city_id_id, :pm25, :pm10, :o3, :o3_8h, :co, :so2, :no2, :aqi)
    end
end
