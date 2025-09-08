class CreateSolidCacheTables < ActiveRecord::Migration[8.0]
  def change
    create_table :solid_cache_entries do |t|
      t.string :key, null: false
      t.string :key_hash, null: false
      t.binary :value, null: false
      t.datetime :created_at, null: false
      t.datetime :expires_at, null: true

      t.index :key_hash, unique: true
      t.index :expires_at
    end

    create_table :solid_cache_versions do |t|
      t.string :key, null: false
      t.string :version, null: false
      t.datetime :created_at, null: false

      t.index [:key, :version], unique: true
    end
  end
end
