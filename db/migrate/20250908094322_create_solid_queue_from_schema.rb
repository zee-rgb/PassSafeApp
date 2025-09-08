class CreateSolidQueueFromSchema < ActiveRecord::Migration[8.0]
  def up
    # Load and execute the SolidQueue schema
    schema_file = Rails.root.join('db', 'queue_schema.rb')
    if File.exist?(schema_file)
      load(schema_file)
    else
      raise "SolidQueue schema file not found at #{schema_file}"
    end
  end

  def down
    # Drop all SolidQueue tables in reverse order of dependency
    [
      'solid_queue_blocked_executions',
      'solid_queue_claimed_executions',
      'solid_queue_failed_executions',
      'solid_queue_pauses',
      'solid_queue_processes',
      'solid_queue_ready_executions',
      'solid_queue_recurring_executions',
      'solid_queue_recurring_tasks',
      'solid_queue_scheduled_executions',
      'solid_queue_semaphores',
      'solid_queue_jobs'
    ].each do |table|
      drop_table table if table_exists?(table.to_sym)
    end
  end
end
