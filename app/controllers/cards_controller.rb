class CardsController < ApplicationController

  before_filter only: [:index] do
    insist_on :logged_in
  end

  before_filter only: [:new_list, :destroy] do
    insist_on :permission, @user
  end

  def new_list
    @card = Card.new
    @card.save!
    new_lookup(:card, @user.top_card.id, :card, @card.id)
    respond_to do |format|
      format.html { back }
      format.js
    end
  end

  def update
    @card = Card.find(params[Card.slug])
    case params[:commit]
    when /.*Order/
      if params[:card][:order].empty?
        back and return
      end
      order = JSON.parse(params[:card][:order].gsub("=>", ":")).inject({}) { |memo, (key, value)| memo[key.to_i>0? key.to_i : nil] = value.collect { |id| id.to_i>0? id.to_i : nil }; memo }
      order.each do |key, value|
        card = Card.find(key)
        card.update_attribute(:cards, value) if can_modify? User.find_by(id: Card.find(order.keys[0]).user_id)
      end
      back and return #only here since we've already updated attributes
    when /Create.*/
      @new_card = Card.new(title: nil)
      @new_card.save!
      @card.cards << @new_card.id
      view_template = "create"
    when /Save.*/
      @card.title = params[:card][:title]
      @card.description = params[:card][:description]
      @card.file_id = Upload.render(params[:card][:upload][:picture], params[:card][:upload][:explicit]) if params[:card][:upload] and params[:card][:upload][:picture]
      view_template = "save"
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
      respond_to do |format|
        format.html { back }
        format.js { render view_template }
      end
    else
      flash[:danger] = "error updating item"
      back
    end
  end

  def destroy
    @card = Card.find(params[Card.slug])
    not_found and return unless @card
    not_found and return if @card == @user.card
    if @user.card.cards.include? @card.id
      @card.cards.collect { |card_id| Card.find(card_id) }.each do |card|
        card.delete
      end
      @user.card.cards.delete @card.id
      @user.card.update_attribute(:cards, @user.card.cards)
    else
      @user.card.cards.collect { |list_id| Card.find(list_id) }.each do |list|
        list.cards.delete @card.id
        list.update_attribute(:cards, list.cards)
      end
    end
    @card.destroy
    respond_to do |format|
      #format.html { back }
      format.js
    end
  end

  private

  def kanban_card_params_permitted
    []
  end
end
