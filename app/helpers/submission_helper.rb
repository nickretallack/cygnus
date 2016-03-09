module SubmissionHelper

  def recent_submissions
    Submission.where("array_to_string(attachments, ',') ~ 'image'").where(hidden: false).order("id desc").limit(20).reverse
  end

end