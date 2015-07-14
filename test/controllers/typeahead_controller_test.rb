require 'test_helper'

class TypeaheadControllerTest < ActionController::TestCase
  test "should get users" do
    get :users
    assert_response :success
  end

  test "should get groups" do
    get :groups
    assert_response :success
  end

  test "should get listables" do
    get :listables
    assert_response :success
  end

  test "should get assets" do
    get :assets
    assert_response :success
  end

end
