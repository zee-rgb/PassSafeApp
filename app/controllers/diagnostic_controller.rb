class DiagnosticController < ApplicationController
  # Only accessible in development
  before_action :ensure_development

  def encryption_keys
    # Check if encryption keys are properly set
    primary_key = ActiveRecord::Encryption.config.primary_key.present?
    deterministic_key = ActiveRecord::Encryption.config.deterministic_key.present?
    key_derivation_salt = ActiveRecord::Encryption.config.key_derivation_salt.present?

    render json: {
      primary_key: primary_key,
      deterministic_key: deterministic_key,
      key_derivation_salt: key_derivation_salt,
      key_lengths: {
        primary_key: ActiveRecord::Encryption.config.primary_key&.length,
        deterministic_key: ActiveRecord::Encryption.config.deterministic_key&.length,
        key_derivation_salt: ActiveRecord::Encryption.config.key_derivation_salt&.length
      }
    }
  end

  private

  def ensure_development
    unless Rails.env.development?
      render json: { error: "Only available in development environment" }, status: :forbidden
    end
  end
end
