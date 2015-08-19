class AddCollabsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :collabs, :boolean
  end
end
