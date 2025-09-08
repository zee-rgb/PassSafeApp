# GitHub Actions Setup Guide

This document explains how the CI workflow is configured to run tests successfully.

## Test Environment Configuration

The GitHub Actions workflow uses predefined encryption keys for the test environment:

```yaml
env:
  RAILS_ENV: test
  DATABASE_URL: postgres://postgres:postgres@localhost:5432/pass_safe_app_test
  # Test-specific encryption keys for CI
  ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY: "0000000000000000000000000000000000000000000000000000000000000000"
  ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY: "1111111111111111111111111111111111111111111111111111111111111111"
  ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT: "2222222222222222222222222222222222222222222222222222222222222222"
```

These keys match the default test keys defined in `config/initializers/active_record_encryption.rb`.

## Production Environment Setup

For production deployment on Render, you'll need to set the following environment variables:

1. `RAILS_MASTER_KEY` - The master key used to decrypt the Rails credentials
2. `ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY` - The 64-character primary key for encryption
3. `ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY` - The 64-character deterministic key
4. `ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT` - The 64-character key derivation salt

You can get these values from your local development environment:

```bash
# Master key
cat config/master.key

# Encryption keys
bin/rails credentials:show
```

## Important Notes

1. **Key Length**: All encryption keys must be 64-character hex strings (32 bytes)
2. **Test Environment**: The test environment uses hardcoded keys for CI
3. **Local Development**: Your local environment should use the keys from credentials

## Troubleshooting

If you see the "key must be 16 bytes" error:

1. Check that encryption keys are 64-character hex strings
2. Ensure the correct environment variables are set
3. Verify that the test environment has the correct default keys

For local testing, you can set environment variables directly:

```bash
ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY="0000000000000000000000000000000000000000000000000000000000000000" \
ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY="1111111111111111111111111111111111111111111111111111111111111111" \
ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT="2222222222222222222222222222222222222222222222222222222222222222" \
bin/rails test
```
