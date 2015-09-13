class Card < ActiveRecord::Base
  belongs_to :user
  belongs_to :card

  def level
    @level ||= -> {
      if user_id
        0
      elsif not cards.empty?
        1
      else
        2
      end
    }.call
  end
end
