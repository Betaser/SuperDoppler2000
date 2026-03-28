require "test_helper"

class Subpage1ControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get subpage1_index_url
    assert_response :success
  end
end
