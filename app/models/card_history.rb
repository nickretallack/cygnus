class CardHistory < ActiveRecord::Base
  belongs_to :card
  
      def image
      children("image").first
    end

    def order
      children("order").first
    end
end
