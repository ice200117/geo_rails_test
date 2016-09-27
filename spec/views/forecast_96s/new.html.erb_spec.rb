require 'rails_helper'

RSpec.describe "forecast_96s/new", type: :view do
  before(:each) do
    assign(:forecast_96, Forecast96.new(
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

  it "renders new forecast_96 form" do
    render

    assert_select "form[action=?][method=?]", forecast_96s_path, "post" do

      assert_select "input#forecast_96_station_id_id[name=?]", "forecast_96[station_id_id]"

      assert_select "input#forecast_96_pattern[name=?]", "forecast_96[pattern]"

      assert_select "input#forecast_96_pm25[name=?]", "forecast_96[pm25]"

      assert_select "input#forecast_96_pm10[name=?]", "forecast_96[pm10]"

      assert_select "input#forecast_96_o3[name=?]", "forecast_96[o3]"

      assert_select "input#forecast_96_o3_8h[name=?]", "forecast_96[o3_8h]"

      assert_select "input#forecast_96_co[name=?]", "forecast_96[co]"

      assert_select "input#forecast_96_so2[name=?]", "forecast_96[so2]"

      assert_select "input#forecast_96_no2[name=?]", "forecast_96[no2]"

      assert_select "input#forecast_96_aqi[name=?]", "forecast_96[aqi]"
    end
  end
end
