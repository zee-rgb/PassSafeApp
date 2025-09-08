# Configure Active Job to use SolidQueue as the queue adapter
Rails.application.config.active_job.queue_adapter = :solid_queue

# Configure SolidQueue based on environment
if defined?(SolidQueue)
  if Rails.env.test?
    # Test environment uses the test adapter
    Rails.application.config.active_job.queue_adapter = :test
  else
    # Production and development use SolidQueue with primary database
    begin
      SolidQueue.connects_to = :primary
      
      # Configure SolidQueue-specific settings
      SolidQueue.supervisor_polling_interval = 1 # seconds
      SolidQueue.shutdown_timeout = 5 # seconds
      
      # Log the configuration
      Rails.logger.info "[SolidQueue] Configured with primary database"
    rescue => e
      Rails.logger.error "[SolidQueue] Failed to configure: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      
      # Fall back to async adapter if SolidQueue configuration fails
      Rails.application.config.active_job.queue_adapter = :async
      Rails.logger.warn "[SolidQueue] Falling back to :async adapter"
    end
  end
end
