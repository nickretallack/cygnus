class KanbanList < ActiveRecord::Base
  belongs_to :user
  has_many :kanban_cards
end
