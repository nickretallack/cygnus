class Card < ActiveRecord::Base
    def list
      parents("card").first
    end

    def cards
      children("card")
    end

    def image
      children("image").first
    end

    def order
      children("order").first
    end
end
