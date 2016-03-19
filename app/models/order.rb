class Order < ActiveRecord::Base

  each_page_show 20

  def user
    parents("user").first
  end

  def patron
    parents("user", "placed_order").first || AnonymousUser.new
  end

  def patron_name
    name.blank?? patron.name : name
  end

  def patron_email
    email.blank?? patron.email : email
  end

end