require 'rails_helper'

RSpec.describe "forecast_72s/new", type: :view do
  before(:each) do
    assign(:forecast_72, Forecast72.new(
      :station_id => nil,
      :pattern => "MyString",
      :pm25 => 1.5,
      :pm10 => 1.5,
      :o3 => 1.5,
      :o3_8h => 1.5,
      :co => 1.5,
      :so2 => 1.5,
      :no2 => 1.5,
      :aqi => 1.5
    ))
  end

  it "renders new forecast_72 form" do
    render

    assert_select "form[action=?][method=?]", forecast_72s_path, "post" do

      assert_select "input#forecast_72_station_id_id[name=?]", "forecast_72[station_id_id]"

      assert_select "input#forecast_72_pattern[name=?]", "forecast_72[pattern]"

      assert_select "input#forecast_72_pm25[name=?]", "forecast_72[pm25]"

      assert_select "input#forecast_72_pm10[name=?]", "forecast_72[pm10]"

      assert_select "input#forecast_72_o3[name=?]", "forecast_72[o3]"

      assert_select "input#forecast_72_o3_8h[name=?]", "forecast_72[o3_8h]"

      assert_select "input#forecast_72_co[name=?]", "forecast_72[co]"

      assert_select "input#forecast_72_so2[name=?]", "forecast_72[so2]"

      assert_select "input#forecast_72_no2[name=?]", "forecast_72[no2]"

      assert_select "input#forecast_72_aqi[name=?]", "forecast_72[aqi]"
    end
  end
end
