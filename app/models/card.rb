class Card < ActiveRecord::Base
    has_many :card_histories, :dependent => :delete_all

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
    
    after_save do
      hist = CardHistory.new(self.attributes)
      hist.assign_attributes(id:nil,card:self)
      hist.save
    end
end
