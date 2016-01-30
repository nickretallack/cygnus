class MakeParentIdAndChildIdArraysInAttachments < ActiveRecord::Migration
  def change
    remove_column :attachments, :child_id, :integer
    add_column :attachments, :child_ids, :integer, array: true, default: []
  end
end
