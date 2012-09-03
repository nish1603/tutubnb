require 'test_helper'

class UserControllerTest < ActionController::TestCase
  test "should get edit" do
    get :edit
    assert_response :success
  end

  test "should get update" do
    get :update
    assert_response :success
  end

  test "should get listings" do
    get :listings
    assert_response :success
  end

  test "should get trips" do
    get :trips
    assert_response :success
  end

  test "should get requests" do
    get :requests
    assert_response :success
  end

end
