class AddSubmissionIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :submission_id, :integer
  end
end
