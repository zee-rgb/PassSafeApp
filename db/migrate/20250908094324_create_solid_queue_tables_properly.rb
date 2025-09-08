class CreateSolidQueueTablesProperly < ActiveRecord::Migration[8.0]
  def change
    # Jobs table
    create_table :solid_queue_jobs, id: :bigint, primary_key: :id do |t|
      t.string :queue_name, null: false
      t.string :class_name, null: false
      t.text :arguments
      t.integer :priority, default: 0, null: false
      t.string :active_job_id
      t.datetime :scheduled_at
      t.datetime :finished_at
      t.string :concurrency_key
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [ :active_job_id ]
      t.index [ :class_name ]
      t.index [ :finished_at ]
      t.index [ :queue_name, :finished_at ], name: 'index_solid_queue_jobs_for_filtering'
      t.index [ :scheduled_at, :finished_at ], name: 'index_solid_queue_jobs_for_alerting'
    end

    # Scheduled Executions
    create_table :solid_queue_scheduled_executions, id: :bigint, primary_key: :id do |t|
      t.references :job, null: false, index: { unique: true }, foreign_key: { to_table: :solid_queue_jobs, on_delete: :cascade }
      t.string :queue_name, null: false
      t.integer :priority, default: 0, null: false
      t.datetime :scheduled_at, null: false
      t.datetime :created_at, null: false
      
      t.index [ :scheduled_at, :priority, :job_id ], name: 'index_solid_queue_dispatch_all'
    end

    # Ready Executions
    create_table :solid_queue_ready_executions, id: :bigint, primary_key: :id do |t|
      t.references :job, null: false, index: { unique: true }, foreign_key: { to_table: :solid_queue_jobs, on_delete: :cascade }
      t.string :queue_name, null: false
      t.integer :priority, default: 0, null: false
      t.datetime :created_at, null: false
      
      t.index [ :priority, :job_id ], name: 'index_solid_queue_poll_all'
      t.index [ :queue_name, :priority, :job_id ], name: 'index_solid_queue_poll_by_queue'
    end

    # Blocked Executions
    create_table :solid_queue_blocked_executions, id: :bigint, primary_key: :id do |t|
      t.references :job, null: false, index: { unique: true }, foreign_key: { to_table: :solid_queue_jobs, on_delete: :cascade }
      t.string :queue_name, null: false
      t.integer :priority, default: 0, null: false
      t.string :concurrency_key, null: false
      t.datetime :expires_at, null: false
      t.datetime :created_at, null: false
      
      t.index [ :concurrency_key, :priority, :job_id ], name: 'index_solid_queue_blocked_executions_for_release'
      t.index [ :expires_at, :concurrency_key ], name: 'index_solid_queue_blocked_executions_for_maintenance'
    end

    # Claimed Executions
    create_table :solid_queue_claimed_executions, id: :bigint, primary_key: :id do |t|
      t.references :job, null: false, index: { unique: true }, foreign_key: { to_table: :solid_queue_jobs, on_delete: :cascade }
      t.bigint :process_id
      t.datetime :created_at, null: false
      
      t.index [ :process_id, :job_id ]
    end

    # Failed Executions
    create_table :solid_queue_failed_executions, id: :bigint, primary_key: :id do |t|
      t.references :job, null: false, index: { unique: true }, foreign_key: { to_table: :solid_queue_jobs, on_delete: :cascade }
      t.text :error
      t.datetime :created_at, null: false
    end

    # Pauses
    create_table :solid_queue_pauses, id: :bigint, primary_key: :id do |t|
      t.string :queue_name, null: false
      t.datetime :created_at, null: false
      
      t.index [ :queue_name ], unique: true
    end

    # Processes
    create_table :solid_queue_processes, id: :bigint, primary_key: :id do |t|
      t.string :kind, null: false
      t.datetime :last_heartbeat_at, null: false
      t.bigint :supervisor_id
      t.integer :pid, null: false
      t.string :hostname
      t.text :metadata
      t.string :name, null: false
      t.datetime :created_at, null: false
      
      t.index [ :last_heartbeat_at ]
      t.index [ :name, :supervisor_id ], unique: true
      t.index [ :supervisor_id ]
    end

    # Recurring Tasks
    create_table :solid_queue_recurring_tasks, id: :bigint, primary_key: :id do |t|
      t.string :key, null: false
      t.string :schedule, null: false
      t.string :command, limit: 2048
      t.string :class_name
      t.text :arguments
      t.string :queue_name
      t.integer :priority, default: 0
      t.boolean :static, default: true, null: false
      t.text :description
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [ :key ], unique: true
      t.index [ :static ]
    end

    # Recurring Executions
    create_table :solid_queue_recurring_executions, id: :bigint, primary_key: :id do |t|
      t.references :job, null: false, index: { unique: true }, foreign_key: { to_table: :solid_queue_jobs, on_delete: :cascade }
      t.string :task_key, null: false
      t.datetime :run_at, null: false
      t.datetime :created_at, null: false
      
      t.index [ :task_key, :run_at ], unique: true
    end

    # Semaphores
    create_table :solid_queue_semaphores, id: :bigint, primary_key: :id do |t|
      t.string :key, null: false
      t.integer :value, default: 1, null: false
      t.datetime :expires_at, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index [ :expires_at ]
      t.index [ :key, :value ]
      t.index [ :key ], unique: true
    end
  end
end
