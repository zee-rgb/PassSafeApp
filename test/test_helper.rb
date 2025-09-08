ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

# Use test adapter for Active Job in test environment
ActiveJob::Base.queue_adapter = :test

# Configure SolidQueue for testing
begin
  require "solid_queue/testing"
  SolidQueue.use_test_adapter
rescue LoadError => e
  puts "SolidQueue testing support not available: #{e.message}"
end

# Load test support files
Dir[Rails.root.join("test/support/**/*.rb")].sort.each do |f| 
  require f rescue puts "Failed to load #{f}: #{$!}"
end

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    include Devise::Test::IntegrationHelpers
    
    # Setup SolidQueue test adapter
    setup do
      if defined?(SolidQueue)
        begin
          SolidQueue.use_main_thread = true
          SolidQueue.pause_all_queues if SolidQueue.respond_to?(:pause_all_queues)
        rescue => e
          puts "Warning: Failed to configure SolidQueue: #{e.message}"
        end
      end
    end
  end
end
