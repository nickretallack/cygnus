class ChangeArtistTypes < ActiveRecord::Migration
  def change
    add_column :users, :artist_types, :string, array: true, default: []
    add_column :users, :offsite_galleries, :string, array: true, default: []
  end
end
