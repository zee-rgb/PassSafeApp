# frozen_string_literal: true

# Centralized configuration for audit events retention
Rails.application.config.x.audit_events = ActiveSupport::OrderedOptions.new

# Default retention days. Can be overridden via ENV.
retention = ENV.fetch("AUDIT_EVENTS_RETENTION_DAYS", 90).to_i
retention = 90 if retention <= 0
retention = 3650 if retention > 3650 # guard against accidental huge values (>10 years)

Rails.application.config.x.audit_events.retention_days = retention
