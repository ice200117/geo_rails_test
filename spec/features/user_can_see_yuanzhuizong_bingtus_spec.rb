require 'rails_helper'

RSpec.feature "UserCanSeeYuanzhuizongBingtus", type: :feature do
  #pending "add some scenarios (or delete) #{__FILE__}"
  background do
    @adj_per = {'保定' =>  54.34, '北京' => 12.25}
  end

  scenario '访问/, 应该显示源追踪的饼图' do
    visit '/'

    @adj_per.each { |key,value| 
      expect(page).to have_content key
      expect(page).to have_content value
    }
  end 
  
end

