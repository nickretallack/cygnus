class RemoveExcess < ActiveRecord::Migration
  def change
    remove_column :users, :watched_by
    remove_column :submissions, :faved_by
  end
end
