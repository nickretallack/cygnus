class CardCell < HelpfulCell

  def show(options)
    @user = options[:user]
    @image_attachments = Attachment.where(parent_model: "card", parent_id: @model.id, child_model: "image")
    if @user.card.cards.include? @model.id
      @cards = @model.cards.collect { |card_id| Card.find(card_id) }
      render "list"
    else
      render "card"
    end
  end

end