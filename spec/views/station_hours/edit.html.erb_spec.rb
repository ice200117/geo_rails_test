require 'rails_helper'

RSpec.describe "station_hours/edit", type: :view do
  before(:each) do
    @station_hour = assign(:station_hour, StationHour.create!(
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

  it "renders the edit station_hour form" do
    render

    assert_select "form[action=?][method=?]", station_hour_path(@station_hour), "post" do

      assert_select "input#station_hour_station_id_id[name=?]", "station_hour[station_id_id]"

      assert_select "input#station_hour_pm25[name=?]", "station_hour[pm25]"

      assert_select "input#station_hour_pm10[name=?]", "station_hour[pm10]"

      assert_select "input#station_hour_o3[name=?]", "station_hour[o3]"

      assert_select "input#station_hour_o3_8h[name=?]", "station_hour[o3_8h]"

      assert_select "input#station_hour_co[name=?]", "station_hour[co]"

      assert_select "input#station_hour_so2[name=?]", "station_hour[so2]"

      assert_select "input#station_hour_no2[name=?]", "station_hour[no2]"

      assert_select "input#station_hour_aqi[name=?]", "station_hour[aqi]"
    end
  end
end
