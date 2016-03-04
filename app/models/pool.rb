class Pool < ActiveRecord::Base
  include LookupHelper

  def Pool.results_per_page
    15
  end

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
