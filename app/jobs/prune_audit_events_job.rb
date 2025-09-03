# frozen_string_literal: true

class PruneAuditEventsJob < ApplicationJob
  queue_as :default

  # Deletes audit events older than the specified number of days (default: 90)
  # Usage: PruneAuditEventsJob.perform_later(90)
  def perform(days = 90)
    cutoff = Time.current - days.to_i.days
    AuditEvent.where("created_at < ?", cutoff).delete_all
  end
end
