class AddStatusesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :statuses, :integer, array: true, default: [0, 0, 0, 0]
  end
end
