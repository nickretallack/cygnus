class AddToComments < ActiveRecord::Migration
  def change
    add_column :comments, :content, :text
    add_column :comments, :user_id, :integer
    add_column :comments, :submission_id, :integer
  end
end
