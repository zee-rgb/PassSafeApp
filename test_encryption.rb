#!/usr/bin/env ruby

require_relative 'config/environment'

# Check if encryption keys are properly set
puts "Checking encryption keys..."
puts "Primary key: #{ActiveRecord::Encryption.config.primary_key.present? ? 'Present' : 'Missing'}"
puts "Primary key length: #{ActiveRecord::Encryption.config.primary_key&.length || 'N/A'}"
puts "Deterministic key: #{ActiveRecord::Encryption.config.deterministic_key.present? ? 'Present' : 'Missing'}"
puts "Deterministic key length: #{ActiveRecord::Encryption.config.deterministic_key&.length || 'N/A'}"
puts "Key derivation salt: #{ActiveRecord::Encryption.config.key_derivation_salt.present? ? 'Present' : 'Missing'}"
puts "Key derivation salt length: #{ActiveRecord::Encryption.config.key_derivation_salt&.length || 'N/A'}"

# Try creating and encrypting a test entry
puts "\nTesting encryption..."
begin
  test_entry = Entry.new(name: "Test Entry", url: "https://example.com", username: "testuser", password: "testpass")
  puts "Entry created successfully"

  # Test username encryption (deterministic)
  encrypted_username = test_entry.username
  puts "Username encrypted successfully: #{encrypted_username.present?}"

  # Test password encryption (non-deterministic)
  encrypted_password = test_entry.password
  puts "Password encrypted successfully: #{encrypted_password.present?}"
rescue => e
  puts "Error during encryption test: #{e.class} - #{e.message}"
  puts e.backtrace.join("\n")
end
