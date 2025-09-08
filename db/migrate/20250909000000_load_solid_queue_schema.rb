class LoadSolidQueueSchema < ActiveRecord::Migration[7.1]
  def up
    # Load the SolidQueue schema
    load(Rails.root.join('db/queue_schema.rb'))
  end

  def down
    # Drop all SolidQueue tables
    connection = ActiveRecord::Base.connection
    connection.execute("DROP TABLE IF EXISTS solid_queue_blocked_executions")
    connection.execute("DROP TABLE IF EXISTS solid_queue_claimed_executions")
    connection.execute("DROP TABLE IF EXISTS solid_queue_failed_executions")
    connection.execute("DROP TABLE IF EXISTS solid_queue_jobs")
    connection.execute("DROP TABLE IF EXISTS solid_queue_pauses")
    connection.execute("DROP TABLE IF EXISTS solid_queue_processes")
    connection.execute("DROP TABLE IF EXISTS solid_queue_ready_executions")
    connection.execute("DROP TABLE IF EXISTS solid_queue_recurring_executions")
    connection.execute("DROP TABLE IF EXISTS solid_queue_scheduled_executions")
    connection.execute("DROP TABLE IF EXISTS solid_queue_semaphores")
  end
end
