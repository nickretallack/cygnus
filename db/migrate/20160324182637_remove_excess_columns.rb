class RemoveExcessColumns < ActiveRecord::Migration
  def change
    remove_column :users, :unread_messages, :integer

    Submission.all.each do |submission|
      submission.update_attribute(:hidden, false)
    end
  end
end
