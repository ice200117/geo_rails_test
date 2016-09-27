require 'rails_helper'

RSpec.describe "CityDailies", type: :request do
  describe "GET /city_dailies" do
    it "works! (now write some real specs)" do
      get city_dailies_path
      expect(response).to have_http_status(200)
    end
  end
end
