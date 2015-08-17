class CreateKanbanLists < ActiveRecord::Migration
  def change
    create_table :kanban_lists do |t|
      t.string :title
      t.integer :user_id
      t.integer :cards, array: true, default: []

      t.timestamps null: false
    end
  end
end
