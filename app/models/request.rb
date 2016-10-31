class Request < ActiveRecord::Base
  belongs_to :user
  belongs_to :image
  has_many :slots, -> {includes(:bids).order("bids.amount DESC")}
  accepts_nested_attributes_for :slots
 
  validates :breed, presence: true, inclusion: { in: ["auction", "request"] }
  validates :max_price, numericality: true, :allow_nil => true
  validates_numericality_of :auction_length
  
  def end_date
    created_at + auction_length.days
  end
  
  def expired?
    Time.now > end_date
  end
end
