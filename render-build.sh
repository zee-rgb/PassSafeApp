#!/usr/bin/env bash
# exit on error
set -o errexit

# Ensure we're in the correct directory
cd "$(dirname "$0")/.."

# Install Ruby dependencies
bundle config set --local deployment 'true'
bundle config set --local without 'development test'
bundle install --jobs 4 --retry 3

# Install JavaScript dependencies
yarn install --frozen-lockfile

# Compile assets
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Run database migrations
bundle exec rails db:migrate

# Clean up old assets
bundle exec rake assets:clean[0]

# Ensure the tmp directory exists
mkdir -p tmp/pids

# Ensure the log directory exists
mkdir -p log

# Ensure the public directory exists
mkdir -p public

# Set proper permissions
chmod -R 755 public/
chmod -R 755 tmp/
