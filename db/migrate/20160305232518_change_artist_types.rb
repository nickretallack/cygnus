class ChangeArtistTypes < ActiveRecord::Migration
  def change
    remove_column :users, :artist_type, :string
    add_column :users, :artist_types, :string, array: true, default: []
    remove_column :users, :offsite_gallery, :string
    add_column :users, :offsite_galleries, :string, array: true, default: []
  end
end
