class Pool < ActiveRecord::Base
  include LookupHelper

  def users
    parents(user: "?", pool: id)
  end

  def user
    @user ||= users.first
  end

  def submission_attachments
    @submission_attachments ||= attachments_for(pool: id, submission: "?")
  end

  def submissions
    children(pool: id, submission: "?")
    #@submissions ||= Submission.where("id = ANY (?)", "{" + submission_attachments.map { |submission| submission.parent_id }.join(",") + "}" )
  end

end
