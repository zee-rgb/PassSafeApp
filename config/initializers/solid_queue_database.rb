# frozen_string_literal: true

# This initializer ensures SolidQueue uses the primary database in production
if defined?(SolidQueue) && Rails.env.production?
  # Configure SolidQueue to use the primary database
  SolidQueue.connects_to = :primary
  
  # Set the same connection pool settings as Active Record
  SolidQueue.connection_pool_size = ActiveRecord::Base.connection_pool.size
  SolidQueue.connection_pool_timeout = ActiveRecord::Base.connection_pool.checkout_timeout
  
  # Log the configuration for debugging
  Rails.logger.info "[SolidQueue] Configured to use primary database in production"
end
