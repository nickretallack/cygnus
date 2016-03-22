class CardsController < ApplicationController

  before_filter only: [:index] do
    insist_on :logged_in
  end

  before_filter only: [:create, :update, :reorder, :destroy] do
    insist_on :permission, @user
  end

  before_filter only: [:index] do
    unless @user.card
      card = Card.new
      card.save(validate: false)
      @user.attachments << "card-#{card.id}"
      @user.save(validate: false)
    end
  end

  def after_save
    card = Card.find(params[Card.slug])
    card.update_attribute(:attachments, card.attachments << "card-#{@card.id}")
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
