class Submission < ActiveRecord::Base

  def pools
    parents("pool")
  end

  def pool
    pools.first
  end

  def uploads
    children("image")
  end

  def upload
    uploads.first || Image.new
  end

  def faved_by
    @faved_by ||= User.where("? = ANY (favs)", id)
  end

  def comments
    @comments ||= Message.where(submission_id: id)
  end
end
