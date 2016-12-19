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
    
    def comments
      children("message")
    end
    
    def order
      children("order").first
    end
    
    def bid
      children("bid").first
    end
    
    after_save do
      ch = self.attachments_change
      ch = ch.last - ch.first if ch
      unless ch.blank? && ch.first.starts_with?("message")
        hist = CardHistory.new(self.attributes)
        hist.assign_attributes(id:nil,card:self)
        hist.save
      end
    end
end
