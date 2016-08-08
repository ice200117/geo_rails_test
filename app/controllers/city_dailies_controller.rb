class CityDailiesController < ApplicationController
  before_action :set_city_daily, only: [:show, :edit, :update, :destroy]

  # GET /city_dailies
  # GET /city_dailies.json
  def index
    @city_dailies = CityDaily.all
  end

  # GET /city_dailies/1
  # GET /city_dailies/1.json
  def show
  end

  # GET /city_dailies/new
  def new
    @city_daily = CityDaily.new
  end

  # GET /city_dailies/1/edit
  def edit
  end

  # POST /city_dailies
  # POST /city_dailies.json
  def create
    @city_daily = CityDaily.new(city_daily_params)

    respond_to do |format|
      if @city_daily.save
        format.html { redirect_to @city_daily, notice: 'City daily was successfully created.' }
        format.json { render :show, status: :created, location: @city_daily }
      else
        format.html { render :new }
        format.json { render json: @city_daily.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /city_dailies/1
  # PATCH/PUT /city_dailies/1.json
  def update
    respond_to do |format|
      if @city_daily.update(city_daily_params)
        format.html { redirect_to @city_daily, notice: 'City daily was successfully updated.' }
        format.json { render :show, status: :ok, location: @city_daily }
      else
        format.html { render :edit }
        format.json { render json: @city_daily.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /city_dailies/1
  # DELETE /city_dailies/1.json
  def destroy
    @city_daily.destroy
    respond_to do |format|
      format.html { redirect_to city_dailies_url, notice: 'City daily was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_city_daily
      @city_daily = CityDaily.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def city_daily_params
      params.require(:city_daily).permit(:city_id_id, :publish_time, :pm25, :pm10, :o3, :o3_8h, :co, :so2, :no2, :aqi)
    end
end
