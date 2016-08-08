require 'rails_helper'

RSpec.describe "forecast_24s/edit", type: :view do
  before(:each) do
    @forecast_24 = assign(:forecast_24, Forecast24.create!(
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

  it "renders the edit forecast_24 form" do
    render

    assert_select "form[action=?][method=?]", forecast_24_path(@forecast_24), "post" do

      assert_select "input#forecast_24_station_id_id[name=?]", "forecast_24[station_id_id]"

      assert_select "input#forecast_24_pattern[name=?]", "forecast_24[pattern]"

      assert_select "input#forecast_24_pm25[name=?]", "forecast_24[pm25]"

      assert_select "input#forecast_24_pm10[name=?]", "forecast_24[pm10]"

      assert_select "input#forecast_24_o3[name=?]", "forecast_24[o3]"

      assert_select "input#forecast_24_o3_8h[name=?]", "forecast_24[o3_8h]"

      assert_select "input#forecast_24_co[name=?]", "forecast_24[co]"

      assert_select "input#forecast_24_so2[name=?]", "forecast_24[so2]"

      assert_select "input#forecast_24_no2[name=?]", "forecast_24[no2]"

      assert_select "input#forecast_24_aqi[name=?]", "forecast_24[aqi]"
    end
  end
end
