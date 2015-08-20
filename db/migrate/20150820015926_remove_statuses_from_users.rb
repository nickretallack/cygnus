class RemoveStatusesFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :commissions
    remove_column :users, :trades
    remove_column :users, :requests
    remove_column :users, :collabs
  end
end
