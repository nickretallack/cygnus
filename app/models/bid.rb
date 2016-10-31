class Bid < ActiveRecord::Base
  belongs_to :slot
  belongs_to :user
  
  validates_numericality_of :amount
  validate :bid_highest
  
  def bid_highest
    if Bid.where(slot_id: slot_id).last.amount > amount
      errors.add(:amount, "bid must be higher than previous bids")
    end    
  end
end
