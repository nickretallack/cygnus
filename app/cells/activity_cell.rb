class ActivityCell < HelpfulCell

  def format
    content = @model.content
    case @model.type.to_sym
    when :status_change
      content = content.gsub(/(#{CONFIG[:activity_icons].keys.join("|")})/){ |match| "<span class = 'inline comm-#{match}'>#{match.gsub("_", " ")}</span>" }
    end
    content = content.gsub("\n", "<br />")
    "#{timestamp(@model, :created)}: #{content}"
  end

  ["index", "unread_messages", "older_messages", "unread"].each do |method|
    define_method method do
      render method
    end
  end

  def new(type, options = {})
    unless current_user.setting(:disable_activity_feed)
      if @model.is_a? Array
        recipients = @model
        recipient = recipients.first
      elsif @model
        recipients = [@model]
        recipient = recipients.first
      else
        recipients = []
      end
      case type
      when :watch
        content = "<span class = 'inline name'>#{link_to current_user.name, user_path(current_user)}</span> watched <span class = 'inline name'>#{link_to recipient.name, user_path(recipient)}</span>."
      when :fav
        content = "#{current_user.name} favorited #{object.pool.user.name}'s submission \u201C#{object.title}\u201D."
      when :new_submission
        content = "#{current_user.name} uploaded a new #{view_context.link_to "submission", submission_path(object)}."
      when :work_request #not implemented
        content = "#{current_user.name} ordered work from #{object.name}."
      when :workboard_update #please do not use yet except for testing; workboards must be quantum updated at present,
                             #and sending a message for each update will flood inboxes
        content = "#{current_user.name} updated their workboard."
      when :commission_finished #not implemented
        content = "#{current_user.name} finished a commission for #{object.name}."
      when :print_order #not implemented
        content = "#{current_user.name} ordered a print of #{object.user.name}'s #{view_context.link_to "submission", submission_path(object)}."
      when :status_change
        content = ""
        object.each do |key, status|
          content << "\n"
          content << "#{current_user.name} has set their #{CONFIG[:commission_icons].keys[key.to_i]} status to #{status}."
        end
      when :comment
        content = "#{current_user.name} posted a comment on #{object.submission.pool.user.name}'s #{view_context.link_to "submission", submission_path(object.submission)}#{" in reply to " + other_user.name if other_user}."
      when :pm
        content = "#{current_user.name} sent #{pm_recipient.name} a PM."
      else
        return
      end
      message = Message.new(content: sanitize(content), attachments: [type])
      message.save(validate: false)
      recipients.each do |user|
        user.update_attribute(:attachments, user.attachments << "unread_message-#{message.id}")
      end
    end
  end

end