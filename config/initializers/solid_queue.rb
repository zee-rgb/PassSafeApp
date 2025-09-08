# Configure Active Job to use SolidQueue as the queue adapter
Rails.application.config.active_job.queue_adapter = :solid_queue

# Configure SolidQueue based on environment
if defined?(SolidQueue)
  if Rails.env.test?
    # Test environment uses the test adapter
    Rails.application.config.active_job.queue_adapter = :test
  else
    begin
      # Configure SolidQueue to use the primary database
      SolidQueue.connects_to = :primary

      # Only set these if the methods exist (they were removed in newer versions)
      if SolidQueue.respond_to?(:supervisor_polling_interval=)
        SolidQueue.supervisor_polling_interval = 1 # seconds
      end

      if SolidQueue.respond_to?(:shutdown_timeout=)
        SolidQueue.shutdown_timeout = 5 # seconds
      end

      Rails.logger.info "[SolidQueue] Configured with primary database"
    rescue => e
      Rails.logger.error "[SolidQueue] Failed to configure: #{e.message}"

      # Fall back to async adapter if SolidQueue configuration fails
      Rails.application.config.active_job.queue_adapter = :async
      Rails.logger.warn "[SolidQueue] Falling back to :async adapter"
    end
  end
end
