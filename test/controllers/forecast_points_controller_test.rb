require 'test_helper'

class ForecastPointsControllerTest < ActionController::TestCase
  setup do
    @forecast_point = forecast_points(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:forecast_points)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create forecast_point" do
    assert_difference('ForecastPoint.count') do
      post :create, forecast_point: { AQI: @forecast_point.AQI, CO: @forecast_point.CO, NO2: @forecast_point.NO2, O3: @forecast_point.O3, SO2: @forecast_point.SO2, VIS: @forecast_point.VIS, forecast_date: @forecast_point.forecast_date, latitude: @forecast_point.latitude, longitude: @forecast_point.longitude, pm10: @forecast_point.pm10, pm25: @forecast_point.pm25, publish_date: @forecast_point.publish_date }
    end

    assert_redirected_to forecast_point_path(assigns(:forecast_point))
  end

  test "should show forecast_point" do
    get :show, id: @forecast_point
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @forecast_point
    assert_response :success
  end

  test "should update forecast_point" do
    patch :update, id: @forecast_point, forecast_point: { AQI: @forecast_point.AQI, CO: @forecast_point.CO, NO2: @forecast_point.NO2, O3: @forecast_point.O3, SO2: @forecast_point.SO2, VIS: @forecast_point.VIS, forecast_date: @forecast_point.forecast_date, latitude: @forecast_point.latitude, longitude: @forecast_point.longitude, pm10: @forecast_point.pm10, pm25: @forecast_point.pm25, publish_date: @forecast_point.publish_date }
    assert_redirected_to forecast_point_path(assigns(:forecast_point))
  end

  test "should destroy forecast_point" do
    assert_difference('ForecastPoint.count', -1) do
      delete :destroy, id: @forecast_point
    end

    assert_redirected_to forecast_points_path
  end
end
