require 'rails_helper'

RSpec.describe "city_hours/new", type: :view do
  before(:each) do
    assign(:city_hour, CityHour.new(
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

  it "renders new city_hour form" do
    render

    assert_select "form[action=?][method=?]", city_hours_path, "post" do

      assert_select "input#city_hour_city_id_id[name=?]", "city_hour[city_id_id]"

      assert_select "input#city_hour_pm25[name=?]", "city_hour[pm25]"

      assert_select "input#city_hour_pm10[name=?]", "city_hour[pm10]"

      assert_select "input#city_hour_o3[name=?]", "city_hour[o3]"

      assert_select "input#city_hour_o3_8h[name=?]", "city_hour[o3_8h]"

      assert_select "input#city_hour_co[name=?]", "city_hour[co]"

      assert_select "input#city_hour_so2[name=?]", "city_hour[so2]"

      assert_select "input#city_hour_no2[name=?]", "city_hour[no2]"

      assert_select "input#city_hour_aqi[name=?]", "city_hour[aqi]"
    end
  end
end
