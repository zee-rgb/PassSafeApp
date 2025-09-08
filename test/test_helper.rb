ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

# Configure SolidQueue for testing
require "solid_queue/testing"

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
      SolidQueue.use_test_adapter if defined?(SolidQueue::Testing)
    end
  end
end
