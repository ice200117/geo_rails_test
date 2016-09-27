require 'rails_helper'

RSpec.describe "Forecast24s", type: :request do
  describe "GET /forecast_24s" do
    it "works! (now write some real specs)" do
      get forecast_24s_path
      expect(response).to have_http_status(200)
    end
  end
end
