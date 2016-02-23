class OrderForm < ActiveRecord::Base

  validates :content, presence: {message: " was blank or submitted incorrectly."}, on: :update
  validate :content_is_array, on: :update
  
  def content_is_array
  	errors.add(:content, "Server Error has Occurred, Please Retry") unless content.is_a? Array
  end

end
