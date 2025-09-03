require "test_helper"

class AuthenticationFlowTest < ActionDispatch::IntegrationTest
  test "user can sign up, sign in, and sign out" do
    # Sign up
    get "/en/secure/sign_up"
    assert_response :success

    assert_difference("User.count") do
      post "/en/secure", params: {
        user: {
          email: "newuser@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end
    assert_redirected_to "/en"

    # Sign out
    delete "/en/secure/sign_out"
    assert_redirected_to "/en"

    # Sign in
    get "/en/secure/sign_in"
    assert_response :success

    post "/en/secure/sign_in", params: {
      user: {
        email: "newuser@example.com",
        password: "password123"
      }
    }
    assert_redirected_to "/en"
  end

  test "user cannot access entries without authentication" do
    get "/en/entries"
    assert_redirected_to "/en/secure/sign_in"

    get "/en/entries/new"
    assert_redirected_to "/en/secure/sign_in"
  end

  test "user can access entries after authentication" do
    user = users(:one)
    sign_in user

    get "/en/entries"
    assert_response :success

    get "/en/entries/new"
    assert_response :success
  end

  test "password reset flow" do
    user = users(:one)

    # Request password reset
    get "/en/secure/password/new"
    assert_response :success

    post "/en/secure/password", params: { user: { email: user.email } }
    assert_redirected_to "/en/secure/sign_in"
  end
end
