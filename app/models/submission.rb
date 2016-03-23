class Submission < ActiveRecord::Base

  def Submission.results_per_page
    20
  end

  def pools
    parents("pool")
  end

  def pool
    pools.first
  end

  def users
    pool.users if pool
  end

  def user
    pool.user if pool
  end

  def images
    children("image")
  end

  def image
    images.first
  end

  def faved_by
    User.where("? = ANY (favs)", id)
  end

  def comments
    children("message", "comment")
  end

  def all_comments
    children("message", "buried_comment")
  end

end
