class CreateSlots < ActiveRecord::Migration
  def change
    create_table :slots do |t|
      t.string :title
      t.references :request, index: true, foreign_key: true
      t.text :body
      t.decimal :min_bid
      t.decimal :auto_buy
      t.timestamps null: false
    end
  end
end
