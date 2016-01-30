class RemoveUserIdFromPools < ActiveRecord::Migration
  def change
    remove_column :pools, :user_id, :integer
  end
end
