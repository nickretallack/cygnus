class CreateCardHistories < ActiveRecord::Migration
  def change
    create_table :card_histories do |t|
      t.references :card, index: true, foreign_key: true
      t.string :title
      t.string :description
      t.string :attachments, array: true, default: []
      t.timestamps null: false
    end
  end
end
