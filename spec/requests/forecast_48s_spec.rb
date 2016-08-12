require 'rails_helper'

RSpec.describe "Forecast48s", type: :request do
  describe "GET /forecast_48s" do
    it "works! (now write some real specs)" do
      get forecast_48s_path
      expect(response).to have_http_status(200)
    end
  end
end
