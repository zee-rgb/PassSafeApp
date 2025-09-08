#!/usr/bin/env ruby
# Run with: rails runner script/generate_encryption_keys.rb

require 'securerandom'

# Generate three 32-byte keys (64 hex characters each)
primary_key = SecureRandom.hex(32)
deterministic_key = SecureRandom.hex(32)
key_derivation_salt = SecureRandom.hex(32)

puts "Generated encryption keys for Rails 8 Active Record Encryption:"
puts
puts "ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY=#{primary_key}"
puts "ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY=#{deterministic_key}"
puts "ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT=#{key_derivation_salt}"
puts
puts "Each key is #{primary_key.length} characters (#{primary_key.length/2} bytes) as required by Rails 8."
puts
puts "Add these to your Render environment variables in the dashboard."
puts "Remember to restart your service after adding these variables."
