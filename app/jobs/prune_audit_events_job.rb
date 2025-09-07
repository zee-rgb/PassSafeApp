# frozen_string_literal: true

class PruneAuditEventsJob < ApplicationJob
  queue_as :default

  # Deletes audit events older than the specified number of days.
  # Defaults to Rails.application.config.x.audit_events.retention_days when days is nil.
  # Supports optional dry-run (no deletion, just counts/logging) and batch deletion to reduce lock time.
  #
  # Backwards compatible usage:
  #   PruneAuditEventsJob.perform_later(90)
  # Keyword usage:
  #   PruneAuditEventsJob.perform_later(days: 90, dry_run: true)
  def perform(days = nil, dry_run: false, batch_size: 10_000)
    retention_days = (days || Rails.application.config.x.audit_events.retention_days).to_i
    retention_days = 90 if retention_days <= 0 # final fallback

    cutoff = Time.current - retention_days.days
    total = 0

    Rails.logger.info("[PruneAuditEventsJob] Starting prune. cutoff=#{cutoff.iso8601} days=#{retention_days} dry_run=#{dry_run} batch_size=#{batch_size}")

    loop do
      ids = AuditEvent.where("created_at < ?", cutoff).limit(batch_size).pluck(:id)
      break if ids.empty?

      if dry_run
        total += ids.length
      else
        deleted = AuditEvent.where(id: ids).delete_all
        total += deleted
      end

      # If fewer than batch_size returned, likely finished next iteration
      break if ids.length < batch_size
    end

    action = dry_run ? "would delete" : "deleted"
    Rails.logger.info("[PruneAuditEventsJob] Completed prune: #{action} #{total} audit events older than #{retention_days} days")

    total
  end
end
