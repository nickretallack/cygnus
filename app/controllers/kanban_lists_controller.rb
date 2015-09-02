class KanbanListsController < ApplicationController
  def index
    @user = User.find(params[User.slug])
    @kanban_lists = @user.kanban_lists.order(:id)
  end

  def create
    @new_kanban_list.user_id = User.find(params[User.slug]).id

    if @new_kanban_list.save
      redirect_to :back
    else
      flash[:danger] = "Error saving list."
      redirect_to :back
    end
  end

  def update
    @kanban_list = KanbanList.find(params[:kanban_list_id])
    @kanban_list.cards = params[:kanban_list][:order].split(",").collect{ |card_id| card_id.to_i }
    if @kanban_list.update_attributes(kanban_list_params)
      redirect_to :back
    else
      flash[:danger] = "Error saving list."
      redirect_to :back
    end
  end

  private

  def kanban_list_params_permitted
    [:title]
  end
end
