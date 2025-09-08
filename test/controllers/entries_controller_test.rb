require "test_helper"

class EntriesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @entry = entries(:one)
    @other_user = users(:two)
    @other_entry = entries(:two)
  end

  test "should get index when logged in" do
    sign_in @user
    get "/en/entries"
    assert_response :success
  end

  test "should redirect index when not logged in" do
    get "/en/entries"
    assert_redirected_to "/en/secure/sign_in"
  end

  test "should get new when logged in" do
    sign_in @user
    get "/en/entries/new"
    assert_response :success
  end

  test "should create entry when logged in" do
    sign_in @user
    assert_difference("Entry.count") do
      post "/en/entries", params: { entry: { name: "Test Entry", url: "https://example.com", username: "testuser", password: "testpass" } }
    end
    assert_redirected_to "/en"
  end

  test "should not create entry with invalid data" do
    sign_in @user
    assert_no_difference("Entry.count") do
      post "/en/entries", params: { entry: { name: "", url: "invalid-url", username: "", password: "" } }
    end
    assert_response :unprocessable_content
  end

  test "should show entry when logged in as owner" do
    sign_in @user
    get "/en/entries/#{@entry.id}"
    assert_response :success
  end

  test "should not show entry when logged in as different user" do
    sign_in @other_user
    get "/en/entries/#{@entry.id}"
    assert_response :not_found
  end

  test "should get edit when logged in as owner" do
    sign_in @user
    get "/en/entries/#{@entry.id}/edit"
    assert_response :success
  end

  test "should update entry when logged in as owner" do
    sign_in @user
    patch "/en/entries/#{@entry.id}", params: { entry: { name: "Updated Name" } }
    assert_redirected_to "/en/entries/#{@entry.id}"
    @entry.reload
    assert_equal "Updated Name", @entry.name
  end

  test "should not update entry when logged in as different user" do
    sign_in @other_user
    patch "/en/entries/#{@entry.id}", params: { entry: { name: "Hacked Name" } }
    assert_response :not_found
  end

  test "should destroy entry when logged in as owner" do
    sign_in @user
    assert_difference("Entry.count", -1) do
      delete "/en/entries/#{@entry.id}"
    end
    assert_redirected_to "/en/entries"
  end

  test "should not destroy entry when logged in as different user" do
    sign_in @other_user
    assert_no_difference("Entry.count") do
      delete "/en/entries/#{@entry.id}"
    end
    assert_response :not_found
  end

  test "should reveal username when logged in as owner" do
    sign_in @user
    post "/en/entries/#{@entry.id}/reveal_username", as: :json
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal "testuser1", json_response["value"]
  end

  test "should reveal password when logged in as owner" do
    sign_in @user
    post "/en/entries/#{@entry.id}/reveal_password", as: :json
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal "securepassword123", json_response["value"]
  end

  test "should not reveal username when logged in as different user" do
    sign_in @other_user
    post "/en/entries/#{@entry.id}/reveal_username", as: :json
    assert_response :not_found
  end

  test "should not reveal password when logged in as different user" do
    sign_in @other_user
    post "/en/entries/#{@entry.id}/reveal_password", as: :json
    assert_response :not_found
  end

  test "should mask username when logged in as owner" do
    sign_in @user
    post "/en/entries/#{@entry.id}/mask_username", as: :json
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal true, json_response["masked"]
  end

  test "should mask password when logged in as owner" do
    sign_in @user
    post "/en/entries/#{@entry.id}/mask_password", as: :json
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal true, json_response["masked"]
  end

  test "should not mask username when logged in as different user" do
    sign_in @other_user
    post "/en/entries/#{@entry.id}/mask_username", as: :json
    assert_response :not_found
  end

  test "should not mask password when logged in as different user" do
    sign_in @other_user
    post "/en/entries/#{@entry.id}/mask_password", as: :json
    assert_response :not_found
  end
end
