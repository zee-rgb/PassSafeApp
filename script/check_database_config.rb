#!/usr/bin/env ruby
# Run with: rails runner script/check_database_config.rb

# This script checks database configuration and SolidQueue setup

puts "Checking database configuration in #{Rails.env} environment..."

# Check database connection
begin
  puts "\nTesting database connection:"
  connection = ActiveRecord::Base.connection
  puts "  Connected to database: #{connection.current_database}"
  puts "  Database adapter: #{connection.adapter_name}"
  puts "  Connection pool size: #{ActiveRecord::Base.connection_pool.size}"
  puts "  Database connection: SUCCESS"
rescue => e
  puts "  Database connection: FAILED"
  puts "  Error: #{e.message}"
end

# Check if database URL is set in production
if Rails.env.production?
  puts "\nChecking DATABASE_URL environment variable:"
  if ENV["DATABASE_URL"].present?
    puts "  DATABASE_URL is set"
  else
    puts "  DATABASE_URL is NOT set - this will cause problems in production"
  end
end

# Check SolidQueue configuration
puts "\nChecking SolidQueue configuration:"
begin
  if defined?(SolidQueue)
    puts "  SolidQueue is defined"

    # Check if SolidQueue tables exist
    tables = [
      "solid_queue_jobs",
      "solid_queue_ready_executions",
      "solid_queue_scheduled_executions",
      "solid_queue_claimed_executions",
      "solid_queue_blocked_executions",
      "solid_queue_failed_executions",
      "solid_queue_pauses"
    ]

    missing_tables = tables.reject { |t| ActiveRecord::Base.connection.table_exists?(t) }

    if missing_tables.empty?
      puts "  All required SolidQueue tables exist"
    else
      puts "  Missing SolidQueue tables: #{missing_tables.join(', ')}"
      puts "  This indicates migrations haven't been run properly"
    end

    # Try to create a test job
    puts "\nTesting job creation:"
    begin
      test_job = AutoMaskEntryJob.set(wait: 1.hour).perform_later(0, "test")
      puts "  Job creation: SUCCESS (job_id: #{test_job.job_id})"
    rescue => e
      puts "  Job creation: FAILED"
      puts "  Error: #{e.message}"
    end
  else
    puts "  SolidQueue is NOT defined - this will cause problems with background jobs"
  end
rescue => e
  puts "  SolidQueue check failed: #{e.message}"
end

# Check SolidCache configuration
puts "\nChecking SolidCache configuration:"
begin
  if defined?(SolidCache)
    puts "  SolidCache is defined"

    # Test cache operations
    begin
      Rails.cache.write("test_key", "test_value")
      test_value = Rails.cache.read("test_key")
      puts "  Cache operations: #{test_value == 'test_value' ? 'SUCCESS' : 'FAILED'}"
    rescue => e
      puts "  Cache operations: FAILED"
      puts "  Error: #{e.message}"
    end
  else
    puts "  SolidCache is NOT defined - this may cause caching issues"
  end
rescue => e
  puts "  SolidCache check failed: #{e.message}"
end

puts "\nDatabase and queue configuration check completed."
