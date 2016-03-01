class Card < ActiveRecord::Base

    def cards
      children("card")
    end

end
