class CreateAuditEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :audit_events do |t|
      t.references :user, null: false, foreign_key: true
      t.references :entry, null: false, foreign_key: true
      t.string :action, null: false
      t.string :ip
      t.string :user_agent, limit: 1000
      t.timestamps
    end
    add_index :audit_events, [ :user_id, :entry_id, :action, :created_at ], name: "index_audit_events_on_actor_entry_action_time"
  end
end
