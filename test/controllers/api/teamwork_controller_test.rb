require 'test_helper'

class Api::TeamworkControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get api_teamwork_login_url
    assert_response :success
  end

end
