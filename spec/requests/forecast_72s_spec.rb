require 'rails_helper'

RSpec.describe "Forecast72s", type: :request do
  describe "GET /forecast_72s" do
    it "works! (now write some real specs)" do
      get forecast_72s_path
      expect(response).to have_http_status(200)
    end
  end
end
