class CardCell < Cell::ViewModel
  include ActionView::RecordIdentifier
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::CaptureHelper

  def list(options)
    @user = options[:user]
    @cards = @model.cards.collect { |card_id| Card.find(card_id) }
    render
  end

  def card(options)
    @user = options[:user]
    render
  end

end