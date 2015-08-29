class AddFileIdToKanbanCards < ActiveRecord::Migration
  def change
    add_column :kanban_cards, :file_id, :integer
  end
end
