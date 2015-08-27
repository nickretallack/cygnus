class AddWatchedByAndWatchingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :watching, :integer, array: true, default: []
    add_column :users, :watched_by, :integer, array: true, default: []
  end
end
