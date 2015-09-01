class AddToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :subject, :string
    add_column :messages, :content, :text
    add_column :messages, :user_id, :integer
    add_column :messages, :sender_id, :integer
  end
end
