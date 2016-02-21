class Pool < ActiveRecord::Base
  include LookupHelper

  def users
    parents("user")
  end

  def user
    users.first
  end

  def submissions
    children("submission")
  end

end
