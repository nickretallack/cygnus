class KanbanCard < ActiveRecord::Base
  belongs_to :kanban_list
end
