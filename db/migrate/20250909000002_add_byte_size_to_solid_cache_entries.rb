class AddByteSizeToSolidCacheEntries < ActiveRecord::Migration[8.0]
  def change
    add_column :solid_cache_entries, :byte_size, :integer, null: true
  end
end
