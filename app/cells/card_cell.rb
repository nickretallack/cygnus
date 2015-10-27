class CardCell < Cell::ViewModel
  include ActionView::RecordIdentifier
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::CaptureHelper

  def show(options)
    @user = options[:user]
    if @user.card.cards.include? @model.id
      @cards = @model.cards.collect { |card_id| Card.find(card_id) }
      render "list"
    else
      render "card"
    end
  end

end