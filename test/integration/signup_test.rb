require 'test_helper'

class SignupTest < ActionController::IntegrationTest
  fixtures :users

  test "Signup of a User" do
    get "/"

    assert_response :success
    assert_template "show"

    get "users/new"

    assert_response :success
    assert_template "new"

    post_via_redirect "/users", :user => { first_name: 'Aditya',
                                          last_name: 'Kapoor',
                                          email: 'adi@ymail.com',
                                          gender: 1
                                        }

    assert_response :success
    assert_template "new"

    post_via_redirect "/users", :user => { first_name: 'Aditya',
                                          last_name: 'Kapoor',
                                          email: 'adi@ymail.com',
                                          gender: 1, 
                                          password: "password",
                                          password_confirmation: "password"
                                        }

    assert_response :success
    assert_template "show"
  end
end