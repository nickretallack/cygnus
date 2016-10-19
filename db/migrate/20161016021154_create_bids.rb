class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.references :slot, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :body
      t.decimal :amount

      t.timestamps null: false
    end
  end
end
