require 'test_helper'

class BasicsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get task1_index_path
    assert_response :success
  end

end
