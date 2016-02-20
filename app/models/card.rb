class Card < ActiveRecord::Base

    def cards
      children(:card, id, :card, "?")
    end

end
