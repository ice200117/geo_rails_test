require 'rails_helper'

RSpec.describe "StationDailies", type: :request do
  describe "GET /station_dailies" do
    it "works! (now write some real specs)" do
      get station_dailies_path
      expect(response).to have_http_status(200)
    end
  end
end
