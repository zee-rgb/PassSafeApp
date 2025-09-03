# frozen_string_literal: true

class UpdateAuditEventsOnDeleteSetNull < ActiveRecord::Migration[8.0]
  def up
    # Allow NULLs on entry_id so we can nullify on delete
    change_column_null :audit_events, :entry_id, true

    # Replace existing FK with ON DELETE SET NULL
    remove_foreign_key :audit_events, :entries if foreign_key_exists?(:audit_events, :entries)
    add_foreign_key :audit_events, :entries, on_delete: :nullify
  end

  def down
    # Revert to NOT NULL and regular FK (no ON DELETE)
    remove_foreign_key :audit_events, :entries if foreign_key_exists?(:audit_events, :entries)
    add_foreign_key :audit_events, :entries

    change_column_null :audit_events, :entry_id, false
  end
end
