module SubmissionHelper
  def recent_submissions
    Submission.all.order("id desc").limit(20).reverse
  end
end