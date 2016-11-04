class Slot < ActiveRecord::Base
  belongs_to :request
  has_many :bids
  
  attr_accessor :bid_flag
  
  validates :min_bid, numericality: true, :allow_nil => true
  validates :auto_buy, numericality: true, :allow_nil => true
  
  def valid_bid?(req, bid)
    return false unless request == req
    return true if req.breed == "request"
    return false unless bid.amount > winning_bid&.amount.to_i
    
    @bid_flag = true if winning_bid
    return true
  end
  
  def winning_bid
    winning_bid ||= bids.first
  end
  
  def next_bid
    1 + (winning_bid&.amount || (min_bid.to_i - 1))
  end
  
  def current_bid
    winning_bid&.amount || "No bids"
  end
end
