require 'rails_helper'

RSpec.describe "city_dailies/index", type: :view do
  before(:each) do
    assign(:city_dailies, [
      CityDaily.create!(
        :city_id => nil,
        :pm25 => 1.5,
        :pm10 => 1.5,
        :o3 => 1.5,
        :o3_8h => 1.5,
        :co => 1.5,
        :so2 => 1.5,
        :no2 => 1.5,
        :aqi => 1.5
      ),
      CityDaily.create!(
        :city_id => nil,
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

  it "renders a list of city_dailies" do
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
