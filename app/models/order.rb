class Order < ActiveRecord::Base

  def user
    parents("user").first
  end

  def patron
    parents("user", "placed_order").first || AnonymousUser.new
  end

end