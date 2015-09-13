module WorkboardHelper
  def cards_order
    order = { "#{@top_card.id}" => @top_card.cards.collect { |id| "#{id}" } }
    @top_card.cards.collect { |id| Card.find(id) }.each do |list|
      order["#{list.id}"] = list.cards.collect { |id| "#{id}" }
    end
    order
  end
end