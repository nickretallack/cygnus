class OrderForm < ActiveRecord::Base

  def user
    parents("user").first
  end

end
