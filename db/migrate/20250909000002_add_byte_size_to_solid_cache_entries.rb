class AddByteSizeToSolidCacheEntries < ActiveRecord::Migration[8.0]
  def change
    # Only add the column if it doesn't already exist
    unless column_exists?(:solid_cache_entries, :byte_size)
      add_column :solid_cache_entries, :byte_size, :integer, null: true
    end
  end
end
