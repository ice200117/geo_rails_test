require 'rails_helper'

RSpec.describe "CityHours", type: :request do
  describe "GET /city_hours" do
    it "works! (now write some real specs)" do
      get city_hours_path
      expect(response).to have_http_status(200)
    end
  end
end
