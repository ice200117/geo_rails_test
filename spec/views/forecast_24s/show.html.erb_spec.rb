require 'rails_helper'

RSpec.describe "forecast_24s/show", type: :view do
  before(:each) do
    @forecast_24 = assign(:forecast_24, Forecast24.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Pattern/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/1.5/)
    expect(rendered).to match(/1.5/)
  end
end
