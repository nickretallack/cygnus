class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :kind
      t.integer :attachment_id
      t.boolean :confirmed, default: false
      t.boolean :decided, default: false

      t.timestamps null: false
    end
  end
end
