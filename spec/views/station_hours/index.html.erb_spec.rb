require 'rails_helper'

RSpec.describe "station_hours/index", type: :view do
  before(:each) do
    assign(:station_hours, [
      StationHour.create!(
        :station_id => nil,
        :pm25 => 1.5,
        :pm10 => 1.5,
        :o3 => 1.5,
        :o3_8h => 1.5,
        :co => 1.5,
        :so2 => 1.5,
        :no2 => 1.5,
        :aqi => 1.5
      ),
      StationHour.create!(
        :station_id => nil,
        :pm25 => 1.5,
        :pm10 => 1.5,
        :o3 => 1.5,
        :o3_8h => 1.5,
        :co => 1.5,
        :so2 => 1.5,
        :no2 => 1.5,
        :aqi => 1.5
      )
    ])
  end

  it "renders a list of station_hours" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end
