class OrderForm < ActiveRecord::Base
  belongs_to :user
  
  #CAREFUL! Object is an array at all times!
  validates :content, presence: {message: " was blank or submitted incorrectly."}
  validate :content_is_proper
  
  def content_is_proper
  	errors.add(:content, "Severe Error has Occured, please retry") unless content.is_a? Array
  end
end
