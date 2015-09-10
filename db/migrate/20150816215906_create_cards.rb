class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :title
      t.string :description
      t.integer :user_id
      t.integer :cards, array: true, default: []
      t.integer :file_id

      t.timestamps null: false
    end
  end
end
