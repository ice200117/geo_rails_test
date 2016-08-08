require 'rails_helper'

RSpec.describe "city_dailies/new", type: :view do
  before(:each) do
    assign(:city_daily, CityDaily.new(
      :city_id => nil,
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

  it "renders new city_daily form" do
    render

    assert_select "form[action=?][method=?]", city_dailies_path, "post" do

      assert_select "input#city_daily_city_id_id[name=?]", "city_daily[city_id_id]"

      assert_select "input#city_daily_pm25[name=?]", "city_daily[pm25]"

      assert_select "input#city_daily_pm10[name=?]", "city_daily[pm10]"

      assert_select "input#city_daily_o3[name=?]", "city_daily[o3]"

      assert_select "input#city_daily_o3_8h[name=?]", "city_daily[o3_8h]"

      assert_select "input#city_daily_co[name=?]", "city_daily[co]"

      assert_select "input#city_daily_so2[name=?]", "city_daily[so2]"

      assert_select "input#city_daily_no2[name=?]", "city_daily[no2]"

      assert_select "input#city_daily_aqi[name=?]", "city_daily[aqi]"
    end
  end
end
