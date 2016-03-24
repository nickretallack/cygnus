class SubmissionData < ActiveRecord::Migration
  def up
    Submission.all.each do |submission|
      submission.update_attribute(:attachments, submission.attachments << "image-#{submission.attributes["file_id"]}") if submission.attributes["file_id"]
      pool = Pool.find(submission.attributes["pool_id"])
      pool.update_attribute(:attachments, pool.attachments << "submission-#{submission.attributes["id"]}")
    end

    remove_column :submissions, :file_id, :integer
    remove_column :submissions, :pool_id, :integer
  end
end
