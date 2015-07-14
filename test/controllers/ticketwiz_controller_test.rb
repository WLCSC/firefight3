require 'test_helper'

class TicketwizControllerTest < ActionController::TestCase
  test "should get topic" do
    get :topic
    assert_response :success
  end

  test "should get target" do
    get :target
    assert_response :success
  end

  test "should get ticket" do
    get :ticket
    assert_response :success
  end

end
