class Submission < ActiveRecord::Base

  def pools
    @attachment ||= Attachment.where("child_model = ? AND ? = ANY (child_ids)", "pool", id)
  end

  def faved_by
    @faved_by ||= User.where("? = ANY (favs)", id)
  end

  def comments
    @comments ||= Message.where(submission_id: id)
  end
end
