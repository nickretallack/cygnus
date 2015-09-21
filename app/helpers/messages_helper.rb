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
  def activity_message(type, object)
    message = Message.new(user_id: -1, recipient_id: current_user.id)
    case type
    when :watch
      message.content = "#{current_user.name} watched #{view_context.link_to object.name, user_path(object)}."
    when :fav
      message.content = "#{current_user.name} favorited #{object.pool.user.name}'s submission titled #{object.title}."
    when :new_submission
      message.content = "#{current_user.name} uploaded a new #{view_context.link_to "submission", submission_path(object)}."
    when :work_request
      message.content = "#{current_user.name} ordered work from #{object.name}."
    when :workboard_update
      message.content = "#{current_user.name} updated their workboard."
    when :commission_finished
      message.content = "#{current_user.name} finished a commission for #{object.name}."
    when :print_order
      message.content = "#{current_user.name} ordered a print of #{object.user.name}'s #{view_context.link_to "submission", submission_path(object)}."
    when :status_change
      message.content = ""
      object.each.with_index do |(key, status), index|
        message.content += "#{current_user.name} has set their #{key} status to #{status}."
        message.content += "\n" unless index == object.length - 1
      end
    else
      return
    end
    message.content = view_context.sanitize(message.content)
    message.save!
  end

  #prepares an activity message for display
  def format_message(message)
    message.content = message.content.gsub(current_user.name, "You").gsub("has", "have").gsub("their", "your") if current_user?(User.find_by(id: message.recipient_id))
    message.content = message.content.gsub(/(#{CONFIG[:activity_icons].keys.join("|")})/, "<span class = 'inline comm-#{'\1'}'>#{'\1'}</span>")
    "#{message.created_at.strftime("%A %B %e, %Y at %l:%M%P %Z").gsub("  ", " ")}: #{message.content}".html_safe
  end
end