class CreateKanbanCards < ActiveRecord::Migration
  def change
    create_table :kanban_cards do |t|
      t.string :title
      t.string :description
      t.integer :kanban_list_id

      t.timestamps null: false
    end
  end
end
