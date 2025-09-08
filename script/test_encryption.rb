#!/usr/bin/env ruby
# Run with: rails runner script/test_encryption.rb

# This script tests Active Record Encryption functionality
# It creates a test entry and tries to encrypt/decrypt values

puts "Testing Active Record Encryption..."

# Check if encryption keys are properly configured
puts "\nChecking encryption keys:"
puts "  primary_key present: #{ActiveRecord::Encryption.config.primary_key.present?}"
puts "  primary_key length: #{ActiveRecord::Encryption.config.primary_key&.length}"
puts "  deterministic_key present: #{ActiveRecord::Encryption.config.deterministic_key.present?}"
puts "  deterministic_key length: #{ActiveRecord::Encryption.config.deterministic_key&.length}"
puts "  key_derivation_salt present: #{ActiveRecord::Encryption.config.key_derivation_salt.present?}"
puts "  key_derivation_salt length: #{ActiveRecord::Encryption.config.key_derivation_salt&.length}"

# Test if we can create and read an encrypted entry
begin
  puts "\nTesting entry creation with encryption:"

  # Find or create a test user
  test_user = User.find_by(email: "test@example.com")
  unless test_user
    puts "  Creating test user..."
    test_user = User.create!(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  # Create a test entry with encrypted fields
  puts "  Creating test entry with encrypted fields..."
  test_entry = test_user.entries.create!(
    name: "Test Entry #{Time.now.to_i}",
    url: "https://example.com",
    username: "test_username",
    password: "test_password"
  )

  entry_id = test_entry.id
  puts "  Created entry with ID: #{entry_id}"

  # Try to read the encrypted fields
  puts "\nTesting decryption:"
  retrieved_entry = Entry.find(entry_id)
  puts "  Retrieved entry ID: #{retrieved_entry.id}"
  puts "  Decrypted username: #{retrieved_entry.username}"
  puts "  Decrypted password: #{retrieved_entry.password}"

  puts "\nEncryption test completed successfully!"
rescue => e
  puts "\nERROR: Encryption test failed!"
  puts "Exception: #{e.class.name}"
  puts "Message: #{e.message}"
  puts "Backtrace:"
  puts e.backtrace.join("\n")
end
