class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :parent_model
      t.integer :parent_id
      t.string :child_model
      t.integer :child_id
      t.boolean :confirmed, default: false
      t.boolean :decided, default: false

      t.timestamps null: false
    end
  end
end
