require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "should have many entries" do
    assert_respond_to @user, :entries
  end

  test "should destroy associated entries when user is destroyed" do
    @user.save
    @user.entries.create!(name: "Test Entry", url: "https://example.com", username: "test", password: "test")
    # Count existing entries for this user (should be 1 from fixture + 1 we just created = 2)
    user_entry_count = @user.entries.count
    assert_difference "Entry.count", -user_entry_count do
      @user.destroy
    end
  end
end
