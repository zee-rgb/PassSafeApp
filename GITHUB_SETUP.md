# GitHub Actions Setup Guide

This document explains how to set up the required GitHub secrets for the CI workflow to run successfully.

## Required Secrets

The GitHub Actions workflow requires the following secrets to be set up in your repository:

1. `RAILS_MASTER_KEY` - The master key used to decrypt the Rails credentials
2. `ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY` - The primary key for Active Record encryption
3. `ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY` - The deterministic key for Active Record encryption
4. `ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT` - The key derivation salt for Active Record encryption

## Setting Up the Secrets

1. Go to your GitHub repository
2. Click on "Settings"
3. In the left sidebar, click on "Secrets and variables" > "Actions"
4. Click on "New repository secret"
5. Add each of the required secrets with their respective values

### Secret Values

You can get the values for these secrets from your local development environment:

#### RAILS_MASTER_KEY

This is the content of your `config/master.key` file:

```bash
cat config/master.key
```

#### Active Record Encryption Keys

These are the keys you've set up in your Rails credentials. You can view them with:

```bash
bin/rails credentials:show
```

Look for the `active_record_encryption` section and copy the values for:

- `primary_key`
- `deterministic_key`
- `key_derivation_salt`

**Important:** Make sure the encryption keys are 64-character hex strings (32 bytes). If they are shorter, they need to be updated as described in the fix for the Render deployment.

## Verifying the Setup

After setting up all the secrets, trigger a new CI run by pushing a commit to your repository. The workflow should now be able to access the encryption keys and run successfully.

## Troubleshooting

If you continue to see the "key must be 16 bytes" error, check that:

1. All secrets are correctly set in GitHub
2. The encryption keys are 64-character hex strings (32 bytes)
3. The workflow is correctly referencing the secrets

Remember that any changes to the encryption keys in your local environment need to be synchronized with the GitHub secrets for CI to work properly.
