# This initializer will automatically fix the solid_cache_entries table schema
# by adding the missing key_hash column if it doesn't exist.
# This can be safely removed after the fix is applied.

Rails.application.config.after_initialize do
  begin
    # Only run in production to avoid affecting development/test databases
    if Rails.env.production?
      Rails.logger.info "Checking if solid_cache_entries.key_hash column exists..."

      # Check if the table exists first
      if ActiveRecord::Base.connection.table_exists?(:solid_cache_entries)
        column_exists = ActiveRecord::Base.connection.column_exists?(:solid_cache_entries, :key_hash)

        if column_exists
          Rails.logger.info "Column key_hash already exists in solid_cache_entries table."
        else
          Rails.logger.info "Adding key_hash column to solid_cache_entries table..."
          ActiveRecord::Base.connection.execute("ALTER TABLE solid_cache_entries ADD COLUMN key_hash VARCHAR NOT NULL DEFAULT ''")

          Rails.logger.info "Creating unique index on key_hash..."
          ActiveRecord::Base.connection.execute("CREATE UNIQUE INDEX index_solid_cache_entries_on_key_hash ON solid_cache_entries(key_hash)")

          # Remove the default constraint after creating the index
          ActiveRecord::Base.connection.execute("ALTER TABLE solid_cache_entries ALTER COLUMN key_hash DROP DEFAULT")

          Rails.logger.info "Successfully added key_hash column to solid_cache_entries table."
        end
      else
        Rails.logger.info "Table solid_cache_entries does not exist yet. Skipping fix."
      end
    end
  rescue => e
    Rails.logger.error "Error fixing solid_cache_entries table: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    # Don't raise the error - we want the application to continue starting up
  end
end
