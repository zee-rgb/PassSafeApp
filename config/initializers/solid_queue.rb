# Configure Active Job to use SolidQueue as the queue adapter
Rails.application.config.active_job.queue_adapter = :solid_queue

# Configure SolidQueue to use the primary database
if defined?(SolidQueue)
  SolidQueue.connects_to = :primary
end
