require 'rails_helper'

RSpec.describe "forecast_96s/index", type: :view do
  before(:each) do
    assign(:forecast_96s, [
      Forecast96.create!(
        :station_id => nil,
        :pattern => "Pattern",
        :pm25 => 1.5,
        :pm10 => 1.5,
        :o3 => 1.5,
        :o3_8h => 1.5,
        :co => 1.5,
        :so2 => 1.5,
        :no2 => 1.5,
        :aqi => 1.5
      ),
      Forecast96.create!(
        :station_id => nil,
        :pattern => "Pattern",
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

  it "renders a list of forecast_96s" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Pattern".to_s, :count => 2
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
