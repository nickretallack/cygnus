class Pool < ActiveRecord::Base

  each_page_show 5
  
  def users
    parents("user")
  end

  def user
    users.first || User.new
  end
  def destroy
    children("submission").each do |child|
      child.destroy
    end
    super
  end
  def submissions
    children("submission")
  end

end
