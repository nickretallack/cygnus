class CardsController < ApplicationController

  before_filter only: [:index] do
    insist_on :logged_in
  end

  before_filter only: [:new_list, :destroy] do
    insist_on :permission, @user
  end

  def after_save
    card = Card.find(params[Card.slug])
    card.update_attribute(:attachments, card.attachments << "card-#{@card.id}")
  end

  def update
    @card.update_attributes(params.require(:card).permit([:title, :description]))
    respond_to do |format|
      format.html {back}
      format.js
    end
  end

  def reorder
    decode = params[:card][:order].collect{|key,value| JSON.parse(value)}.map{|element| key, value = element.first; [key, value]}.to_h
    @user.card.update_attribute(:attachments, decode.keys.map{|key| "card-#{key}"})
    decode.each do |key, value|
      card = Card.find(key.to_i)
      card.update_attribute(:attachments, value.map{ |value| "card-#{value}" })
    end
    #raise "break"
    respond_to do |format|
      format.html {back}
      format.js
    end
  end

  def destroy
    if @user.card.attachments.include? "card-#{@card.id}"
      @card.cards.each do |card|
        card.destroy
      end
      @user.attachments.delete("card-#{@card.id}")
      @user.update_attribute(:attachments, @user.attachments)
      @card.destroy
    else
      @card.list.attachments.delete("card-#{@card.id}")
      @card.list.update_attribute(:attachments, @card.list.attachments)
      @card.destroy
    end
    back
  end

end
