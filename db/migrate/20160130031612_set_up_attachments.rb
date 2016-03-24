class SetUpAttachments < ActiveRecord::Migration

  def up
    add_column :users, :attachments, :string, array: true, default: []
    rename_column :users, :gallery, :offsite_gallery
    add_column :pools, :attachments, :string, array: true, default: []
    add_column :submissions, :attachments, :string, array: true, default: []
    add_column :cards, :attachments, :string, array: true, default: []
  end

end
