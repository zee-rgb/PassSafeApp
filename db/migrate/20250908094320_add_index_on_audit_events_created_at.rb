# frozen_string_literal: true

class AddIndexOnAuditEventsCreatedAt < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def up
    unless index_exists?(:audit_events, :created_at, name: "index_audit_events_on_created_at")
      add_index :audit_events, :created_at, name: "index_audit_events_on_created_at", algorithm: :concurrently
    end
  end

  def down
    remove_index :audit_events, name: "index_audit_events_on_created_at" if index_exists?(:audit_events, :created_at, name: "index_audit_events_on_created_at")
  end
end
