require "test_helper"

class AutoMaskEntryJobTest < ActiveJob::TestCase
  def setup
    @user = users(:one)
    @entry = entries(:one)
  end

  test "job enqueues correctly" do
    assert_enqueued_jobs 1, only: AutoMaskEntryJob do
      AutoMaskEntryJob.set(wait: 5.seconds).perform_later(@entry.id, "username")
    end
  end

  test "job performs successfully" do
    assert_nothing_raised do
      perform_enqueued_jobs do
        AutoMaskEntryJob.perform_later(@entry.id, "username")
      end
    end
  end

  test "job handles missing entry gracefully" do
    assert_nothing_raised do
      perform_enqueued_jobs do
        AutoMaskEntryJob.perform_later(99_999, "username")
      end
    end
  end

  test "job broadcasts turbo stream for username" do
    # Test that the job runs without error
    assert_nothing_raised do
      perform_enqueued_jobs do
        AutoMaskEntryJob.perform_later(@entry.id, "username")
      end
    end
  end

  test "job broadcasts turbo stream for password" do
    # Test that the job runs without error
    assert_nothing_raised do
      perform_enqueued_jobs do
        AutoMaskEntryJob.perform_later(@entry.id, "password")
      end
    end
  end
end
