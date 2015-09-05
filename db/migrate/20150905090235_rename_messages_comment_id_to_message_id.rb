class RenameMessagesCommentIdToMessageId < ActiveRecord::Migration
  def change
    rename_column :messages, :comment_id, :message_id
  end
end
