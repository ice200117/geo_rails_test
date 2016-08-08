require 'rails_helper'

RSpec.describe "Forecast96s", type: :request do
  describe "GET /forecast_96s" do
    it "works! (now write some real specs)" do
      get forecast_96s_path
      expect(response).to have_http_status(200)
    end
  end
end
