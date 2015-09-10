class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :password_digest
      t.string :email
      t.string :level
      t.inet :ip_address
      t.string :gallery
      t.string :price
      t.text :details
      t.integer :statuses, array: true, default: [0, 0, 0, 0]
      t.string :tags, :string
      t.tsvector :tags_tsvector
      t.integer :avatar
      t.boolean :view_adult, default: false
      t.string :activation_digest
      t.datetime :activated_at
      t.datetime :reset_sent_at
      t.integer :watching, array: true, default: []
      t.integer :watched_by, array: true, default: []
      t.index :tags_tsvector, using: :gin
      t.string :artist_type

      t.timestamps null: false
    end
    execute "DROP TRIGGER IF EXISTS users_tags_search_update ON users;"
    execute "CREATE TRIGGER users_tags_search_update BEFORE INSERT OR UPDATE OF tags ON users FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger(tags_tsvector, 'pg_catalog.english', tags);"
  end
end
