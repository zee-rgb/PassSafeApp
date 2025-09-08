#!/usr/bin/env ruby

require_relative '../config/environment'

puts "=== SolidQueue Configuration Check ==="
puts "Rails Environment: #{Rails.env}"
puts "ActiveJob Queue Adapter: #{ActiveJob::Base.queue_adapter_name}"

if defined?(SolidQueue)
  puts "\nSolidQueue is defined"
  puts "SolidQueue connected to: #{SolidQueue.connects_to.inspect}"
  
  # Check if tables exist
  begin
    puts "\nChecking SolidQueue tables..."
    tables = ActiveRecord::Base.connection.tables
    solid_queue_tables = tables.select { |t| t.start_with?('solid_queue_') }
    
    if solid_queue_tables.any?
      puts "Found SolidQueue tables:"
      solid_queue_tables.each { |t| puts "- #{t}" }
    else
      puts "WARNING: No SolidQueue tables found in the database!"
    end
    
    # Try to access a SolidQueue model
    if defined?(SolidQueue::Job)
      puts "\nSolidQueue::Job is defined"
      count = SolidQueue::Job.count rescue nil
      puts "Number of jobs in queue: #{count}"
    end
    
  rescue => e
    puts "\nERROR checking SolidQueue tables: #{e.message}"
    puts e.backtrace.first(5).join("\n")
  end
else
  puts "\nWARNING: SolidQueue is not defined. Check your Gemfile and bundle install."
end

puts "\n=== Check Complete ==="
