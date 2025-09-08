require "solid_queue"

SolidQueue.configure do |config|
  config.connects_to = {
    database: {
      writing: :primary,
      reading: :primary_replica
    }
  }
end
