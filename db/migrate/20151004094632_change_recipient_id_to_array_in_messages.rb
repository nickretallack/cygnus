class ChangeRecipientIdToArrayInMessages < ActiveRecord::Migration
  def change
    remove_column :messages, :recipient_id, :integer
    add_column :messages, :recipient_ids, :integer, array: true, default: []
  end
end
