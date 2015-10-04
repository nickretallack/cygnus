class ChangeStatusesToStringArray < ActiveRecord::Migration
  def change
    remove_column :users, :statuses, :integer, array: true, default: [0, 0, 0, 0]
    add_column :users, :statuses, :string, array: true, default: ["not_interested", "not_interested", "not_interested", "not_interested"]
  end
end
