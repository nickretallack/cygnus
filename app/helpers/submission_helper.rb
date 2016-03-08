module SubmissionHelper

  def recent_submissions
    Submission.where("(select array_to_string(attachments, ',') from submissions) ~ 'image'").where(hidden: false).order("id desc").limit(20).reverse
  end

end