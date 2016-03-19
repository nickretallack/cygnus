class Pool < ActiveRecord::Base

  each_page_show 15
  
  def users
    parents("user")
  end

  def user
    users.first || User.new
  end

  def submissions
    children("submission")
  end

end
