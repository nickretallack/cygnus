class AddFavs < ActiveRecord::Migration
  def change
    add_column :users, :favs, :integer, array: true, default: []
    add_column :submissions, :faved_by, :integer, array: true, default: []
  end
end