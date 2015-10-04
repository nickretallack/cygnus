module MessagesHelper

  def pm_direction(pm)
    unless current_user.id == pm.user_id
      "received"
    else
      "sent"
    end
  end

  def comment_direction(comment)
    if current_user.comments_made.include? comment
      "sent"
    elsif current_user.comments_received.include? comment
      "received"
    else
      ""
    end
  end

  #generates a new activity message correlating to a user's action and saves it in the database
  #example:
  #
  # Message.system_message(:watch, user)
  #
  def activity_message(type, object = nil)
    message = Message.new(user_id: -1, recipient_ids: [current_user.id])
    case type
    when :watch
      message.content = "#{current_user.name} watched #{view_context.link_to object.name, user_path(object)}."
      message.recipient_ids += [object.id]
    when :fav
      message.content = "#{current_user.name} favorited #{object.pool.user.name}'s submission titled #{object.title}."
      message.recipient_ids += [object.pool.user.id]
    when :new_submission
      message.content = "#{current_user.name} uploaded a new #{view_context.link_to "submission", submission_path(object)}."
      message.recipient_ids += current_user.watched_by.collect { |user| user.id }
    when :work_request #not implemented
      message.content = "#{current_user.name} ordered work from #{object.name}."
      message.recipient_ids += [object.id]
    when :workboard_update #please do not use yet except for testing; workboards must be quantum updated at present,
                           #and sending a message for each update will flood inboxes
      message.content = "#{current_user.name} updated their workboard."
    when :commission_finished #not implemented
      message.content = "#{current_user.name} finished a commission for #{object.name}."
      message.recipient_ids += [object.id]
    when :print_order #not implemented
      message.content = "#{current_user.name} ordered a print of #{object.user.name}'s #{view_context.link_to "submission", submission_path(object)}."
      message.recipient_ids += [object.user.id]
    when :status_change
      message.content = ""
      object.each do |key, status|
        message.content += "\n"
        message.content += "#{current_user.name} has set their #{CONFIG[:commission_icons].keys[key.to_i]} status to #{status}."
      end
      message.recipient_ids += current_user.watched_by.collect { |user| user.id }
    when :comment
      other_user = Message.find(object.message_id).user if object.message_id
      message.content = "#{current_user.name} posted a comment on #{object.submission.pool.user.name}'s #{view_context.link_to "submission", submission_path(object.submission)}#{" in reply to " + other_user.name if other_user}."
      message.recipient_ids += [object.submission.pool.user.id] unless current_user? object.submission.pool.user
      message.recipient_ids += [other_user.id] if other_user and not current_user? other_user
    when :pm
      pm_recipient = User.find_by(id: object.recipient_ids[0]) || Message.find(object.message_id).user
      message.content = "#{current_user.name} sent #{pm_recipient.name} a PM."
      message.recipient_ids += [pm_recipient.id] unless current_user? pm_recipient
    else
      return
    end
    message.content = view_context.sanitize(message.content)
    message.save!
    message.recipient_ids.each do |user_id|
      User.find_by(id: user_id).update_attribute(:unread_messages, current_user.unread_messages+1)
    end
  end

  #prepares an activity message for display
  def format_message(message)
    message.content = message.content.gsub(/(#{CONFIG[:activity_icons].keys.join("|")})/, "<span class = 'inline comm-#{'\1'}'>#{'\1'}</span>")
    "#{message.timestamp(:created)}: #{message.content}".gsub("\n", "<br />").html_safe
  end
end