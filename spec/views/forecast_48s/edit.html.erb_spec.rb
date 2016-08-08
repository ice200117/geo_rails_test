require 'rails_helper'

RSpec.describe "forecast_48s/edit", type: :view do
  before(:each) do
    @forecast_48 = assign(:forecast_48, Forecast48.create!(
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

  it "renders the edit forecast_48 form" do
    render

    assert_select "form[action=?][method=?]", forecast_48_path(@forecast_48), "post" do

      assert_select "input#forecast_48_station_id_id[name=?]", "forecast_48[station_id_id]"

      assert_select "input#forecast_48_pattern[name=?]", "forecast_48[pattern]"

      assert_select "input#forecast_48_pm25[name=?]", "forecast_48[pm25]"

      assert_select "input#forecast_48_pm10[name=?]", "forecast_48[pm10]"

      assert_select "input#forecast_48_o3[name=?]", "forecast_48[o3]"

      assert_select "input#forecast_48_o3_8h[name=?]", "forecast_48[o3_8h]"

      assert_select "input#forecast_48_co[name=?]", "forecast_48[co]"

      assert_select "input#forecast_48_so2[name=?]", "forecast_48[so2]"

      assert_select "input#forecast_48_no2[name=?]", "forecast_48[no2]"

      assert_select "input#forecast_48_aqi[name=?]", "forecast_48[aqi]"
    end
  end
end
