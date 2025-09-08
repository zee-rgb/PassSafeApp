# Allow legacy plaintext data in encrypted columns to be read/updated without raising
# This is useful while migrating existing records to the new encryption scheme.
if Rails.env.production?
  Rails.application.config.active_record.encryption.support_unencrypted_data = false
else
  Rails.application.config.active_record.encryption.support_unencrypted_data = true
end

# Explicitly set encryption keys from ENV or credentials to avoid boot issues
c = Rails.application.config.active_record.encryption
creds = Rails.application.credentials.dig(:active_record_encryption)

# In test, ensure deterministic dummy keys if none provided
test_defaults = Rails.env.test? ? {
  primary_key: "0" * 64,
  deterministic_key: "1" * 64,
  key_derivation_salt: "2" * 64
} : {}

c.primary_key ||= ENV["ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY"] || creds&.fetch(:primary_key, nil) || test_defaults[:primary_key]
c.deterministic_key ||= ENV["ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY"] || creds&.fetch(:deterministic_key, nil) || test_defaults[:deterministic_key]
c.key_derivation_salt ||= ENV["ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT"] || creds&.fetch(:key_derivation_salt, nil) || test_defaults[:key_derivation_salt]
