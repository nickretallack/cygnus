class FixTagsTsvectorInUsers < ActiveRecord::Migration
  def change
    execute <<-SQL
      DROP TRIGGER IF EXISTS users_tags_search_update ON users;
      CREATE TRIGGER users_tags_search_update BEFORE INSERT OR UPDATE
      ON users FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(tags_tsvector, 'pg_catalog.english', tags);
    SQL
  end
end
