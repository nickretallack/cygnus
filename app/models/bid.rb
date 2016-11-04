class Bid < ActiveRecord::Base
  belongs_to :slot
  belongs_to :user
  
  validates_numericality_of :amount
  
end
