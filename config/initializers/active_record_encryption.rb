# Allow legacy plaintext data in encrypted columns to be read/updated without raising
# This is useful while migrating existing records to the new encryption scheme.
# Allow unencrypted data in all environments temporarily
# This helps with existing data that might have been encrypted with different keys
Rails.application.config.active_record.encryption.support_unencrypted_data = true

# Explicitly set encryption keys from ENV or credentials to avoid boot issues
c = Rails.application.config.active_record.encryption
creds = Rails.application.credentials.dig(:active_record_encryption)

# In test, ensure deterministic dummy keys if none provided
test_defaults = Rails.env.test? ? {
  primary_key: "0" * 64,
  deterministic_key: "1" * 64,
  key_derivation_salt: "2" * 64
} : {}

# Log key presence and length for debugging
if Rails.env.development? || Rails.env.production?
  env_primary = ENV["ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY"].present?
  env_deterministic = ENV["ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY"].present?
  env_salt = ENV["ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT"].present?

  creds_primary = creds&.dig(:primary_key).present?
  creds_deterministic = creds&.dig(:deterministic_key).present?
  creds_salt = creds&.dig(:key_derivation_salt).present?

  Rails.logger.info("Active Record Encryption key sources:")
  Rails.logger.info("  ENV keys present: primary=#{env_primary}, deterministic=#{env_deterministic}, salt=#{env_salt}")
  Rails.logger.info("  Credentials keys present: primary=#{creds_primary}, deterministic=#{creds_deterministic}, salt=#{creds_salt}")
end

c.primary_key ||= ENV["ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY"] || creds&.fetch(:primary_key, nil) || test_defaults[:primary_key]
c.deterministic_key ||= ENV["ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY"] || creds&.fetch(:deterministic_key, nil) || test_defaults[:deterministic_key]
c.key_derivation_salt ||= ENV["ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT"] || creds&.fetch(:key_derivation_salt, nil) || test_defaults[:key_derivation_salt]

# Validate key lengths
if Rails.env.development? || Rails.env.production?
  primary_key_length = c.primary_key&.length
  deterministic_key_length = c.deterministic_key&.length
  key_derivation_salt_length = c.key_derivation_salt&.length

  Rails.logger.info("Active Record Encryption key lengths:")
  Rails.logger.info("  primary_key: #{primary_key_length || 'nil'} chars")
  Rails.logger.info("  deterministic_key: #{deterministic_key_length || 'nil'} chars")
  Rails.logger.info("  key_derivation_salt: #{key_derivation_salt_length || 'nil'} chars")

  # Rails 8 requires 32 bytes (64 hex chars) for encryption keys
  if primary_key_length != 64 || deterministic_key_length != 64 || key_derivation_salt_length != 64
    Rails.logger.error("ENCRYPTION KEY ERROR: One or more encryption keys have incorrect length!")
    Rails.logger.error("Rails 8 requires 32-byte keys (64 hex characters)")
  end
end
