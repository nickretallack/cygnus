class CardsController < ApplicationController

  #before_filter only: [:index] do
   # insist_on :logged_in
  #end

  before_filter only: [:create, :update, :reorder, :destroy] do
    insist_on :permission, @user
  end

  before_filter only: [:comment] do
    insist_on :logged_in
  end
  
  before_filter only: [:index] do
    @title = "#{@user.name}'s work log"
    unless @user.card
      card = Card.new
      card.save(validate: false)
      @user.attachments << "card-#{card.id}"
      @user.save(validate: false)
    end
  end
  
  def history
    updates = CardHistory.all.where(card_id: params[Card.slug])
    comments = Card.find(params[Card.slug]).comments
    @histories = (updates + comments).sort_by(&:updated_at).reverse
    @card = Card.find(params[Card.slug])
    @title = "#{@card.title}'s history"    
  end

  def after_save
    card = Card.find(params[Card.slug])
    card.update_attribute(:attachments, card.attachments << "card-#{@card.id}")
  end
  
  def comment
    @card = Card.find(params[Card.slug])
    if @card && @card.order
      @message = Message.new(subject: params[:message][:subject], content: params[:message][:content])
      respond_to do |format|
        if @message.save
          current_user.update_attribute(:attachments, current_user.attachments << "comment-#{@message.id}")
          @card.update_attribute(:attachments, @card.attachments << "message-#{@message.id}")
          if anon?
            patron = {name: @card.order.name, email: @card.order.email, ignore: true}
          else
            patron = {name: @card.order.patron.name, email: @card.order.patron.email, user: @card.order.patron}
          end
          if current_user == @user
             Message.comment_card(@card, @user,
                        {recipient: patron, sender: {name: @user.name}})           
          else
             Message.comment_card(@card, @user,
                        {recipient: {name: @user.name, email: @user.email, user: @user}, sender: patron})
          end

          format.html{
            flash[:success] = "comment created"
            back
          }
        end
      end
    else
      raise ActionController::RoutingError.new('Card Not Found')
    end
  end
  
  def before_update
    update_image_attachment("image") unless @card.list == @user.card
    @card.title = params[:card][:title]
    @card.description = params[:card][:description]
  end

  def reorder
    decode = params[:card][:order].collect{|key,value| JSON.parse(value)}.map{|element| key, value = element.first; [key, value]}.to_h
    @user.card.update_attribute(:attachments, decode.keys.map{|key| "card-#{key}"})
    decode.each do |key, value|
      card = Card.find(key.to_i)
      card.update_attribute(:attachments, value.map{ |value| "card-#{value}" })
    end
    success_routes
  end

  def destroy
    if @user.card.attachments.include? "card-#{@card.id}"
      @word = "list"
      @card.cards.each do |card|
        card.destroy
      end
      @user.attachments.delete("card-#{@card.id}")
      @user.update_attribute(:attachments, @user.attachments)
      @card.destroy
    else
      @word = "card"
      @card.list.attachments.delete("card-#{@card.id}")
      @card.list.update_attribute(:attachments, @card.list.attachments)
      @card.destroy
    end
    success_routes("#{@word} destroyed")
  end

end
