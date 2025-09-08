#!/usr/bin/env ruby
# Run with: RAILS_ENV=production rails runner script/check_encryption_keys.rb

# This script checks if encryption keys are properly configured in the current environment

puts "Checking Active Record Encryption configuration in #{Rails.env} environment..."

# Get encryption configuration
config = ActiveRecord::Encryption.config

# Check key presence
puts "\nKey presence:"
puts "  primary_key present: #{config.primary_key.present?}"
puts "  deterministic_key present: #{config.deterministic_key.present?}"
puts "  key_derivation_salt present: #{config.key_derivation_salt.present?}"

# Check key lengths
puts "\nKey lengths:"
puts "  primary_key: #{config.primary_key&.length || 'nil'} chars"
puts "  deterministic_key: #{config.deterministic_key&.length || 'nil'} chars"
puts "  key_derivation_salt: #{config.key_derivation_salt&.length || 'nil'} chars"

# Check if keys are valid (Rails 8 requires 32-byte keys = 64 hex chars)
valid_length = 64
primary_valid = config.primary_key&.length == valid_length
deterministic_valid = config.deterministic_key&.length == valid_length
salt_valid = config.key_derivation_salt&.length == valid_length

puts "\nKey validity (should be 64 chars):"
puts "  primary_key valid: #{primary_valid}"
puts "  deterministic_key valid: #{deterministic_valid}"
puts "  key_derivation_salt valid: #{salt_valid}"

# Check overall status
all_valid = primary_valid && deterministic_valid && salt_valid
puts "\nOverall encryption key status: #{all_valid ? 'VALID' : 'INVALID'}"

if !all_valid
  puts "\nERROR: Encryption keys are not properly configured!"
  puts "Rails 8 requires 32-byte keys (64 hex characters) for encryption."
  puts "Please check your environment variables or credentials."
else
  puts "\nEncryption keys are properly configured."
end

# Check if we can encrypt/decrypt a test value using a test model
begin
  puts "\nTesting encryption/decryption with Entry model:"

  # Create a temporary entry to test encryption
  test_entry = Entry.new(name: "Test Entry", url: "https://example.com",
                         username: "test_username", password: "test_password")

  # Try to access encrypted attributes (this will use encryption)
  username = test_entry.username
  password = test_entry.password

  puts "  Username encryption test: #{username == 'test_username' ? 'PASSED' : 'FAILED'}"
  puts "  Password encryption test: #{password == 'test_password' ? 'PASSED' : 'FAILED'}"
rescue => e
  puts "  Encryption/decryption test: FAILED"
  puts "  Error: #{e.message}"
  puts "  Backtrace: #{e.backtrace.join("\n    ")}"
end
