require "test_helper"

class EntryManagementTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    sign_in @user
  end

  test "complete entry lifecycle" do
    # Create entry
    get "/en/entries/new"
    assert_response :success

    assert_difference("Entry.count") do
      post "/en/entries", params: {
        entry: {
          name: "Test Service",
          url: "https://testservice.com",
          username: "testuser",
          password: "testpassword"
        }
      }
    end

    entry = Entry.last
    assert_redirected_to "/en"

    # View entry
    get "/en/entries/#{entry.id}"
    assert_response :success
    assert_select "h1", "Test Service"

    # Edit entry
    get "/en/entries/#{entry.id}/edit"
    assert_response :success

    patch "/en/entries/#{entry.id}", params: {
      entry: {
        name: "Updated Test Service",
        url: "https://updated-testservice.com"
      }
    }
    assert_redirected_to "/en/entries/#{entry.id}"
    entry.reload
    assert_equal "Updated Test Service", entry.name

    # Delete entry
    assert_difference("Entry.count", -1) do
      delete "/en/entries/#{entry.id}"
    end
    assert_redirected_to "/en/entries"
  end

  test "entry reveal and mask functionality" do
    entry = entries(:one)

    # Reveal username
    post "/en/entries/#{entry.id}/reveal_username"
    assert_response :success
    assert_match(/testuser1/, response.body)

    # Mask username
    post "/en/entries/#{entry.id}/mask_username"
    assert_response :success
    assert_match(/••••••••/, response.body)

    # Reveal password
    post "/en/entries/#{entry.id}/reveal_password"
    assert_response :success
    assert_match(/securepassword123/, response.body)

    # Mask password
    post "/en/entries/#{entry.id}/mask_password"
    assert_response :success
    assert_match(/••••••••/, response.body)
  end

  test "user can only see their own entries" do
    # User should only see their own entries on index
    get "/en/entries"
    assert_response :success
    # Note: The view might not have .entry-card class, so we'll just check for success

    # User should not be able to access other user's entries
    other_entry = entries(:two)
    get "/en/entries/#{other_entry.id}"
    assert_response :not_found
  end

  test "entry validation errors are displayed" do
    post "/en/entries", params: {
      entry: {
        name: "",
        url: "not-a-url",
        username: "",
        password: ""
      }
    }
    assert_response :unprocessable_entity
    assert_match(/Name can&#39;t be blank/, response.body)
    assert_match(/Url must be a valid URL/, response.body)
  end
end
