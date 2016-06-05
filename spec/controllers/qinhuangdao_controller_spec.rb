require 'rails_helper'

RSpec.describe QinhuangdaoController, type: :controller do
	describe 'GET #get_rank_chart_data' do
		it 'assigns @rank' do
			get :get_rank_chart_data
			expect(assigns(:rank)).to eq(true)
		end
	end

end
