class KanbanCardsController < ApplicationController
  def create
    @new_kanban_card = KanbanCard.new(kanban_card_params)
    @new_kanban_card.kanban_list_id = params[:kanban_list_id]

    if @new_kanban_card.save
      @kanban_list = KanbanList.find(params[:kanban_list_id])
      @kanban_list.update_attribute(:cards, (@kanban_list.cards << @new_kanban_card.id))
      redirect_to :back
    else
      flash[:danger] = "Error saving item."
      redirect_to :back
    end
  end

  def update
    @kanban_card = KanbanCard.find(params[:kanban_card_id])

    if @kanban_card.update_attributes(kanban_card_params)
      @kanban_list = KanbanList.find params[:kanban_list_id]
      index = [0, @kanban_list.cards.index(@kanban_card.id)-params[:kanban_card][:order].to_i, @kanban_list.cards.length-1].sort[1]
      @kanban_list.cards.delete(@kanban_card.id)
      @kanban_list.update_attribute(:cards, @kanban_list.cards.insert(index, @kanban_card.id))
      redirect_to :back
    else
      flash[:danger] = "Error updating item."
      redirect_to :back
    end
  end

  private

  def kanban_card_params
    params.require(:kanban_card).permit(:title)
  end
end
