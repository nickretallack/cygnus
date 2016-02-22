class Submission < ActiveRecord::Base

  def uploads
    children("image")
  end

  def upload
    uploads.first
  end

  def faved_by
    @faved_by ||= User.where("? = ANY (favs)", id)
  end

  def comments
    @comments ||= Message.where(submission_id: id)
  end
end
