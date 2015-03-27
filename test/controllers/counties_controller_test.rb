require 'test_helper'

class CountiesControllerTest < ActionController::TestCase
  test "should get lookup" do
    get :lookup
    assert_response :success
  end

end
