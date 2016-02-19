class DeleteCardsFromCards < ActiveRecord::Migration
  def change
    remove_column :cards, :cards, :integer, array: true, default: []
  end
end
