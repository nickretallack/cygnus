class MessagesData < ActiveRecord::Migration
  def up
    User.reset_column_information
    Message.where(user_id: -1).each do |activity|
      activity.attributes["recipient_ids"].each do |recipient_id|
        user = User.find_by(id: recipient_id)
        user.update_attribute(:attachments, user.attachments << "message-#{activity.attributes["id"]}")
      end
    end

    Message.where.not(submission_id: nil).each do |comment|
      user = User.find_by(id: comment.attributes["user_id"])
      user.update_attribute(:attachments, user.attachments << "comment-#{comment.attributes["id"]}")
      submission = Submission.find(comment.attributes["submission_id"])
      submission.update_attribute(:attachments, submission.attachments << "comment-#{comment.attributes["id"]}")
    end

    Message.where.not(user_id: -1).where(submission_id: nil).each do |pm|
      if pm.attributes["message_id"]
        message = Message.find(pm.attributes["message_id"])
        message.update_attribute(:attachments, message.attachments << "pm-#{pm.attributes["id"]}")
      end
      user = User.find_by(id: pm.attributes["user_id"])
      user.update_attribute(:attachments, user.attachments << "pm_sent-#{pm.attributes["id"]}" << "pm-#{pm.attributes["id"]}")
      if pm.attributes["recipient_ids"].any?
        recipient = User.find_by(id: pm.attributes["recipient_ids"].first)
        recipient.update_attribute(:attachments, recipient.attachments << "read_pm-#{pm.attributes["id"]}" << "pm-#{pm.attributes["id"]}")
      end
    end

    remove_column :messages, :user_id, :integer
    remove_column :messages, :recipient_ids, :integer, array: true, default: []
    remove_column :messages, :message_id, :integer
    remove_column :messages, :submission_id, :integer
  end
end
