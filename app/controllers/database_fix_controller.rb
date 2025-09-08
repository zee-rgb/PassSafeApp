class DatabaseFixController < ApplicationController
  # Skip authentication for this controller
  skip_before_action :authenticate_user!, if: -> { respond_to?(:authenticate_user!) }

  # This action will fix the database schema
  def fix_solid_cache
    # Only allow in production with a secret key
    if Rails.env.production? && params[:secret] != ENV["DATABASE_FIX_SECRET"]
      render plain: "Unauthorized", status: :unauthorized
      return
    end

    begin
      # Check if key_hash column exists
      column_exists = ActiveRecord::Base.connection.column_exists?(:solid_cache_entries, :key_hash)

      if column_exists
        render plain: "Column key_hash already exists in solid_cache_entries table."
      else
        # Add key_hash column
        ActiveRecord::Base.connection.execute("ALTER TABLE solid_cache_entries ADD COLUMN key_hash VARCHAR NOT NULL DEFAULT ''")

        # Create unique index
        ActiveRecord::Base.connection.execute("CREATE UNIQUE INDEX index_solid_cache_entries_on_key_hash ON solid_cache_entries(key_hash)")

        # Remove default constraint
        ActiveRecord::Base.connection.execute("ALTER TABLE solid_cache_entries ALTER COLUMN key_hash DROP DEFAULT")

        render plain: "Successfully added key_hash column to solid_cache_entries table."
      end
    rescue => e
      render plain: "Error: #{e.message}\n#{e.backtrace.join("\n")}", status: :internal_server_error
    end
  end
end
