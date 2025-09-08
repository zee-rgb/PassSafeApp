#!/bin/bash

# Stop any running Rails server
kill -9 $(lsof -i :3000 -t) 2>/dev/null

# Drop the database
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 rails db:drop

# Create the database
rails db:create

# Run migrations
rails db:migrate

# Seed the database if needed
# rails db:seed

echo "Database has been reset and migrations have been run."
