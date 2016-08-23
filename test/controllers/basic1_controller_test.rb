require 'test_helper'

class Basic1ControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get basic1_index_url
    assert_response :success
  end

end
