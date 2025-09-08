namespace :database_fix do
  desc "Add key_hash column to solid_cache_entries table"
  task add_key_hash_column: :environment do
    begin
      puts "Connecting to database..."
      ActiveRecord::Base.connection_pool.with_connection do |conn|
        puts "Checking if key_hash column exists..."
        column_exists = conn.column_exists?(:solid_cache_entries, :key_hash)

        if column_exists
          puts "Column key_hash already exists in solid_cache_entries table."
        else
          puts "Adding key_hash column to solid_cache_entries table..."
          conn.execute("ALTER TABLE solid_cache_entries ADD COLUMN key_hash VARCHAR NOT NULL DEFAULT ''")
          puts "Creating unique index on key_hash..."
          conn.execute("CREATE UNIQUE INDEX index_solid_cache_entries_on_key_hash ON solid_cache_entries(key_hash)")

          # Remove the default constraint after creating the index
          conn.execute("ALTER TABLE solid_cache_entries ALTER COLUMN key_hash DROP DEFAULT")

          puts "Successfully added key_hash column to solid_cache_entries table."
        end
      end
    rescue => e
      puts "Error: #{e.message}"
      puts e.backtrace.join("\n")
      raise
    end
  end
end
