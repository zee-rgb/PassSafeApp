require "test_helper"

class EntryTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @entry = entries(:one)
  end

  test "should be valid" do
    assert @entry.valid?
  end

  test "name should be present" do
    @entry.name = ""
    assert_not @entry.valid?
  end

  test "name should not be too long" do
    @entry.name = "a" * 256
    assert_not @entry.valid?
  end

  test "url should be present" do
    @entry.url = ""
    assert_not @entry.valid?
  end

  test "url should be valid format" do
    valid_urls = %w[https://example.com http://test.org https://sub.domain.com/path]
    valid_urls.each do |valid_url|
      @entry.url = valid_url
      assert @entry.valid?, "#{valid_url.inspect} should be valid"
    end
  end

  test "url should reject invalid formats" do
    invalid_urls = %w[not-a-url ftp://example.com javascript:alert('xss')]
    invalid_urls.each do |invalid_url|
      @entry.url = invalid_url
      assert_not @entry.valid?, "#{invalid_url.inspect} should be invalid"
    end
  end

  test "username should be present on create" do
    entry = Entry.new(name: "Test", url: "https://example.com", password: "test", user: @user)
    entry.username = ""
    assert_not entry.valid?
  end

  test "password should be present on create" do
    entry = Entry.new(name: "Test", url: "https://example.com", username: "test", user: @user)
    entry.password = ""
    assert_not entry.valid?
  end

  test "username should not be too long" do
    entry = Entry.new(name: "Test", url: "https://example.com", username: "a" * 256, password: "test", user: @user)
    assert_not entry.valid?
  end

  test "password should not be too long" do
    entry = Entry.new(name: "Test", url: "https://example.com", username: "test", password: "a" * 256, user: @user)
    assert_not entry.valid?
  end

  test "should belong to user" do
    assert_respond_to @entry, :user
    assert_equal @user, @entry.user
  end

  test "username should be encrypted" do
    entry = Entry.create!(name: "Test", url: "https://example.com", username: "testuser", password: "testpass", user: @user)
    raw_data = Entry.connection.execute("SELECT username FROM entries WHERE id = #{entry.id}").first
    assert_not_equal "testuser", raw_data["username"]
  end

  test "password should be encrypted" do
    entry = Entry.create!(name: "Test", url: "https://example.com", username: "testuser", password: "testpass", user: @user)
    raw_data = Entry.connection.execute("SELECT password FROM entries WHERE id = #{entry.id}").first
    assert_not_equal "testpass", raw_data["password"]
  end

  test "should be able to decrypt username" do
    original_username = "testuser"
    @entry.username = original_username
    @entry.save
    @entry.reload
    assert_equal original_username, @entry.username
  end

  test "should be able to decrypt password" do
    original_password = "testpassword"
    @entry.password = original_password
    @entry.save
    @entry.reload
    assert_equal original_password, @entry.password
  end
end
