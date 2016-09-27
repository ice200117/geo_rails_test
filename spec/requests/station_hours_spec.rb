require 'rails_helper'

RSpec.describe "StationHours", type: :request do
  describe "GET /station_hours" do
    it "works! (now write some real specs)" do
      get station_hours_path
      expect(response).to have_http_status(200)
    end
  end
end
