require 'rails_helper'

RSpec.describe "station_dailies/edit", type: :view do
  before(:each) do
    @station_daily = assign(:station_daily, StationDaily.create!(
      :station_id => nil,
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

  it "renders the edit station_daily form" do
    render

    assert_select "form[action=?][method=?]", station_daily_path(@station_daily), "post" do

      assert_select "input#station_daily_station_id_id[name=?]", "station_daily[station_id_id]"

      assert_select "input#station_daily_pm25[name=?]", "station_daily[pm25]"

      assert_select "input#station_daily_pm10[name=?]", "station_daily[pm10]"

      assert_select "input#station_daily_o3[name=?]", "station_daily[o3]"

      assert_select "input#station_daily_o3_8h[name=?]", "station_daily[o3_8h]"

      assert_select "input#station_daily_co[name=?]", "station_daily[co]"

      assert_select "input#station_daily_so2[name=?]", "station_daily[so2]"

      assert_select "input#station_daily_no2[name=?]", "station_daily[no2]"

      assert_select "input#station_daily_aqi[name=?]", "station_daily[aqi]"
    end
  end
end
