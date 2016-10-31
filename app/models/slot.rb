class Slot < ActiveRecord::Base
  belongs_to :request
  has_many :bids
  
  validates :min_bid, numericality: true, :allow_nil => true
  validates :auto_buy, numericality: true, :allow_nil => true

  def next_bid
    1 + (bids.first&.amount || (min_bid.to_i - 1))
  end
  
  def current_bid
    bids.first&.amount || "No bids"
  end
end
