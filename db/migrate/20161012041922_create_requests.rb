class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :title
      t.text :body
      t.references :image
      t.references :user, index: true, foreign_key: true
      t.string :breed, null: false
      t.decimal :max_price
      t.integer :auction_length, null: false

      t.timestamps null: false
    end
  end
end
