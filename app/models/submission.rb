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

  def images
    children("image")
  end

  def image
    images.first || Image.new
  end

  def faved_by
    @faved_by ||= User.where("? = ANY (favs)", id)
  end

  def comments
    @comments = children("message", "comment")
  end
end
