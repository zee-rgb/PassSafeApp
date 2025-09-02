# Allow legacy plaintext data in encrypted columns to be read/updated without raising
# This is useful while migrating existing records to the new encryption scheme.
Rails.application.config.active_record.encryption.support_unencrypted_data = true
