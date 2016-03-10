class FixMessages < ActiveRecord::Migration
  def change
    remove_column :messages, :user_id, :integer
    remove_column :messages, :recipient_id, :integer
    remove_column :messages, :message_id, :integer
    remove_column :messages, :submission_id, :integer
    add_column :messages, :attachments, :string, array: true, default: []
  end
end
