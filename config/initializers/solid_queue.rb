# Configure SolidQueue based on environment
if defined?(SolidQueue)
  if Rails.env.test?
    # Test environment uses the test adapter
    Rails.application.config.active_job.queue_adapter = :test
    Rails.logger.info "[SolidQueue] Using :test adapter in test environment"
  else
    begin
      # Set the queue adapter
      Rails.application.config.active_job.queue_adapter = :solid_queue
      
      # Configure SolidQueue to use the primary database
      # This will be overridden in production.rb if needed
      unless Rails.env.production?
        SolidQueue.connects_to = :primary
      end

      # Set reasonable defaults if methods exist
      if SolidQueue.respond_to?(:supervisor_polling_interval=)
        SolidQueue.supervisor_polling_interval = 1 # seconds
      end

      if SolidQueue.respond_to?(:shutdown_timeout=) && !Rails.env.production?
        SolidQueue.shutdown_timeout = 5 # seconds
      end

      Rails.logger.info "[SolidQueue] Configured with primary database in #{Rails.env} environment"
    rescue => e
      Rails.logger.error "[SolidQueue] Failed to configure: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")

      # Fall back to async adapter if SolidQueue configuration fails
      Rails.application.config.active_job.queue_adapter = :async
      Rails.logger.warn "[SolidQueue] Falling back to :async adapter"
    end
  end
else
  Rails.logger.warn "[SolidQueue] SolidQueue is not defined. Make sure the gem is in your Gemfile."
  Rails.application.config.active_job.queue_adapter = :async
end
