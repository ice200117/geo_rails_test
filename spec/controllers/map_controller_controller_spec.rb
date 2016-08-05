require 'rails_helper'

RSpec.describe MapControllerController, type: :controller do

  describe "GET #coal" do
    it "returns http success" do
      get :coal
      expect(response).to have_http_status(:success)
    end
  end

end
