class RenameCommentsToMessages < ActiveRecord::Migration
  def change
    rename_table :comments, :messages
  end
end
