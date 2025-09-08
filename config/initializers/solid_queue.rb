if defined?(SolidQueue) && SolidQueue.respond_to?(:configure)
  SolidQueue.configure do |config|
    config.connects_to = {
      database: {
        writing: :primary,
        reading: :primary_replica
      }
    }
  end
end
