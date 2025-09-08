Rails.application.reloader.to_prepare do
  if defined?(SolidQueue) && SolidQueue.respond_to?(:configure)
    SolidQueue.configure do |config|
      # Use primary database connection for both reading and writing
      config.connects_to = {
        database: :primary
      }
    end
  end
end
