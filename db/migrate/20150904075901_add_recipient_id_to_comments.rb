class AddRecipientIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :recipient_id, :integer
  end
end
