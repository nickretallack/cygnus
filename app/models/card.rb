class Card < ActiveRecord::Base

    def list
      parents("card").first
    end

    def cards
      children("card")
    end

end
