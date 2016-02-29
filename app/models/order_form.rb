class OrderForm < ActiveRecord::Base

  validate :content_is_array, on: :update
  
  def content_is_array
  	errors.add(:content, "Server Error has Occurred, Please Retry") unless content.is_a? Array
  end

  def user
    parents("user").first
  end

end
