# frozen_string_literal: true

namespace :audit_events do
  desc "Prune audit events older than DAYS (default 90)"
  task prune: :environment do
    days = (ENV["DAYS"] || 90).to_i
    puts "Pruning audit events older than #{days} days..."
    PruneAuditEventsJob.perform_now(days)
    puts "Done."
  end
end
