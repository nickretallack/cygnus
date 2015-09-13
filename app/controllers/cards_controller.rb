class CardsController < ApplicationController
  def index
    @user = User.find(params[User.slug])
    @top_card = @user.card
    unless @user.card
      Card.new(user_id: @user.id).save!
      redirect_to request.path
    end
  end

  def update
    @card = Card.find(params[Card.slug])
    case params[:commit]
    when /Create.*/
      @new_card = Card.new(title: params[:card][:title])
      @new_card.save!
      @card.cards << @new_card.id
    when "Save"
      @card.title = params[:card][:title]
      @card.description = params[:card][:description]
      @card.file_id = Upload.render(params[:card][:upload][:picture], params[:card][:upload][:explicit]) if params[:card][:upload][:picture]
    end
    if @card.update_attributes(@card.attributes)
    # @kanban_card.file_id = Upload.render(params[:kanban_card][:upload][:picture], params[:kanban_card][:upload][:explicit]) unless params[:kanban_card][:upload][:picture].nil?
    # Upload.find(@kanban_card.file_id).update_attribute(:explicit, params[:kanban_card][:upload][:explicit]) unless @kanban_card.file_id.nil?
    # if @kanban_card.update_attributes(kanban_card_params)
    #   case params[:kanban_card][:order]
    #   when "Move Up"
    #     order = 1
    #   when "Move Down"
    #     order = -1
    #   else
    #     order = params[:kanban_card][:order]
    #   end
    #   @kanban_list = KanbanList.find params[:kanban_list_id]
    #   index = [0, @kanban_list.cards.index(@kanban_card.id)-order.to_i, @kanban_list.cards.length-1].sort[1]
    #   @kanban_list.cards.delete(@kanban_card.id)
    #   @kanban_list.update_attribute(:cards, @kanban_list.cards.insert(index, @kanban_card.id))
      back
    else
      flash[:danger] = "Error updating item."
      back
    end
  end

  def destroy
    raise "break"
  end

  private

  def kanban_card_params_permitted
    []
  end
end
