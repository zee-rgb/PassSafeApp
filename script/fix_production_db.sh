#!/bin/bash
# This script runs the database fix script in production
# It uses the DATABASE_URL from your Render environment

echo "Running database fix script in production..."
RAILS_ENV=production bundle exec ruby script/add_key_hash_column.rb

echo "Done!"
