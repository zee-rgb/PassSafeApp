require "test_helper"

class SolidQueueTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "should use test adapter in test environment" do
    assert_equal :test, ActiveJob::Base.queue_adapter_name.to_sym
  end

  test "SolidQueue should be configured for testing" do
    if defined?(SolidQueue)
      if SolidQueue.respond_to?(:use_main_thread)
        assert SolidQueue.use_main_thread, "SolidQueue should be configured to use main thread in test"
      else
        skip "SolidQueue.use_main_thread is not available"
      end
    else
      skip "SolidQueue is not defined"
    end
  end

  test "can enqueue and perform a job in test environment" do
    # Test enqueuing a job without performing it
    assert_enqueued_with(job: AutoMaskEntryJob) do
      AutoMaskEntryJob.perform_later(1, "test")
    end

    # Clear enqueued jobs
    queue_adapter.enqueued_jobs.clear

    # Test performing the job
    perform_enqueued_jobs do
      AutoMaskEntryJob.perform_later(1, "test")
    end

    # Should have one performed job
    assert_performed_jobs 1
  end
end
