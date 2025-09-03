# Ensures Active Record Encryption keys are present in production
# Rails looks for keys in credentials (active_record_encryption.*) or ENV vars
# ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY, ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY, ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT

if Rails.env.production?
  cfg = Rails.application.config.active_record.encryption

  missing = []
  missing << :primary_key unless cfg.primary_key.present?
  missing << :deterministic_key unless cfg.deterministic_key.present?
  missing << :key_derivation_salt unless cfg.key_derivation_salt.present?

  if missing.any?
    if ENV["SKIP_ENCRYPTION_GUARD"] == "1"
      warn_msg = "[WARN] Active Record Encryption incomplete. Missing: #{missing.join(", ")}. Skipped by SKIP_ENCRYPTION_GUARD=1"
      if defined?(Rails) && Rails.respond_to?(:logger) && Rails.logger
        Rails.logger.warn(warn_msg)
      else
        warn warn_msg
      end
    else
      raise "Active Record Encryption is not fully configured. Missing: #{missing.join(", ")}. Configure credentials or ENV variables."
    end
  end
end
