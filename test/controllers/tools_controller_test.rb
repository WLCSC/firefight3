require 'test_helper'

class ToolsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get checkin" do
    get :checkin
    assert_response :success
  end

  test "should get checkout" do
    get :checkout
    assert_response :success
  end

  test "should get borrow" do
    get :borrow
    assert_response :success
  end

  test "should get return" do
    get :return
    assert_response :success
  end

  test "should get print_form" do
    get :print_form
    assert_response :success
  end

end
