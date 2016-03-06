class ChangeArtistTypes < ActiveRecord::Migration
  def change
    remove_column :users, :artist_type, :string
    add_column :users, :artist_types, :string, array: true, default: []
  end
end
