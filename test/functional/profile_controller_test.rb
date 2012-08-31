require 'test_helper'

class ProfileControllerTest < ActionController::TestCase
  test "should get login" do
    get :login
    assert_response :success
  end

  test "should get logout" do
    get :logout
    assert_response :success
  end

  test "should get signup" do
    get :signup
    assert_response :success
  end

  test "should get save" do
    get :save
    assert_response :success
  end

end
