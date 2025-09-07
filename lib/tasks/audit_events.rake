# frozen_string_literal: true

namespace :audit_events do
  desc "Prune audit events older than DAYS (default 90)"
  task prune: :environment do
    days = (ENV["DAYS"].presence || Rails.application.config.x.audit_events.retention_days).to_i
    dry_run = ENV["DRY_RUN"] == "1"
    puts "Pruning audit events older than #{days} days... dry_run=#{dry_run}"
    PruneAuditEventsJob.perform_now(days, dry_run: dry_run)
    puts "Done."
  end
end
