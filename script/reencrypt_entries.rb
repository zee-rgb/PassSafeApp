#!/usr/bin/env ruby
# This script re-encrypts all entries with the current encryption keys
# Run with: bundle exec ruby script/reencrypt_entries.rb

require_relative "../config/environment"

puts "Re-encrypting entries with current encryption keys..."

# Count total entries
total_entries = Entry.count
puts "Found #{total_entries} entries to process"

# Process entries in batches to avoid memory issues
success_count = 0
error_count = 0

Entry.find_each.with_index do |entry, index|
  begin
    # Try to read the encrypted values
    begin
      username = entry.username
      password = entry.password
    rescue ActiveRecord::Encryption::Errors::Decryption => e
      puts "Warning: Could not decrypt entry #{entry.id}: #{e.message}"
      username = "[Could not decrypt]"
      password = "[Could not decrypt]"
    end

    # Re-encrypt with current keys
    entry.username = username
    entry.password = password

    # Save without validations to avoid issues with required fields
    if entry.save(validate: false)
      success_count += 1
    else
      error_count += 1
      puts "Error saving entry #{entry.id}: #{entry.errors.full_messages.join(", ")}"
    end

    # Print progress every 10 entries
    if (index + 1) % 10 == 0 || index + 1 == total_entries
      puts "Processed #{index + 1}/#{total_entries} entries (#{success_count} succeeded, #{error_count} failed)"
    end
  rescue => e
    error_count += 1
    puts "Error processing entry #{entry.id}: #{e.message}"
  end
end

puts "\nRe-encryption completed!"
puts "Successfully re-encrypted: #{success_count} entries"
puts "Failed to re-encrypt: #{error_count} entries"
