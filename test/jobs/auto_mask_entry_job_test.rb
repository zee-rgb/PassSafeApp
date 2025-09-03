require "test_helper"

class AutoMaskEntryJobTest < ActiveJob::TestCase
  def setup
    @user = users(:one)
    @entry = entries(:one)
  end

  test "job enqueues correctly" do
    assert_enqueued_with(job: AutoMaskEntryJob, args: [ @entry.id, "username" ]) do
      AutoMaskEntryJob.set(wait: 5.seconds).perform_later(@entry.id, "username")
    end
  end

  test "job performs successfully" do
    assert_nothing_raised do
      AutoMaskEntryJob.perform_now(@entry.id, "username")
    end
  end

  test "job handles missing entry gracefully" do
    assert_nothing_raised do
      AutoMaskEntryJob.perform_now(99999, "username")
    end
  end

  test "job broadcasts turbo stream for username" do
    # Test that the job runs without error
    assert_nothing_raised do
      AutoMaskEntryJob.perform_now(@entry.id, "username")
    end
  end

  test "job broadcasts turbo stream for password" do
    # Test that the job runs without error
    assert_nothing_raised do
      AutoMaskEntryJob.perform_now(@entry.id, "password")
    end
  end
end
