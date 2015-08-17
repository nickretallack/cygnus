class KanbanListsController < ApplicationController
  def index
    @user = User.find(params[:id])
    @kanban_lists = @user.kanban_lists.order(:id)
  end

  def create
    @user = User.find(params[:id])
    @new_kanban_list = KanbanList.new(kanban_list_params)
    @new_kanban_list.user_id = @user.id

    if @new_kanban_list.save
      redirect_to :back
    else
      flash[:danger] = "Error making new list."
      redirect_to :back
    end
  end

  private

  def kanban_list_params
    params.require(:kanban_list).permit(:title)
  end
end
