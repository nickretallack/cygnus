class ActivityCell < HelpfulCell

  def format
    content = @model.content
    case (@model.type.to_sym rescue "")
    when :status_change
      content = content.gsub(/(#{CONFIG[:activity_icons].keys.join("|")})/){ |match| "<span class = 'inline comm-#{match}'>#{match.gsub("_", " ")}</span>" }
    else
      content = @model.content
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
      if @model.is_a? Array or @model.is_a? ActiveRecord::Relation
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
        content = "#{link_to current_user.name, user_path(current_user)} watched you"
      when :fav
        recipients << options[:submission].user
        content = "#{link_to current_user.name, user_path(current_user)} favorited your submission \u201C#{link_to title_for(options[:submission]), submission_path(options[:submission].pool, options[:submission])}\u201D"
      when :submission
        content = "#{link_to current_user.name, user_path(current_user)} just created or updated their submission, \u201C#{link_to title_for(options[:submission]), submission_path(options[:submission].pool, options[:submission])}\u201D"
      when :order
        content = "#{options[:order].name || link_to(current_user.name, user_path(current_user))} placed a commission order with you"
      when :accept_order
        recipients << options[:order].patron
        content = "#{link_to current_user.name, user_path(current_user)} accepted your #{link_to "commission order", order_path(options[:order])}"
      when :reject_order
        recipients << options[:order].patron
        content = "#{link_to current_user.name, user_path(current_user)} rejected your #{link_to "commission order", order_path(options[:order])}"
      when :workboard_update #not implemented
        content = "#{link_to current_user.name, user_path(current_user)} updated the status of your commission order on their #{link_to "workboard", cards_path(current_user)}"
      when :print_order #not implemented
        content = "#{current_user.name} ordered a print of #{object.user.name}'s #{view_context.link_to "submission", submission_path(object)}."
      when :status_change
        content = "#{link_to current_user.name, user_path(current_user)} has updated their statuses to: "
        content << current_user.statuses.map.with_index{ |status, index| "#{CONFIG[:commission_icons].keys[index]}: <span class = 'inline comm-#{status}'>#{status}</span>" }.join("; ")
      when :comment
        recipients << options[:submission].user
        content = "#{link_to current_user.name, user_path(current_user)} commented on your submission, \u201C#{link_to title_for(options[:submission]), submission_path(options[:submission].pool, options[:submission])}\u201D"
      when :pm #not implemented
        content = "you received a PM from #{link_to current_user.name, user_path(current_user)}"
      else
        return
      end
      message = Message.new(content: sanitize(content), attachments: [type])
      message.save(validate: false)
      recipients.each do |user|
        user.update_attribute(:attachments, user.attachments << "unread_message-#{message.id}")
      end
      #raise "break"
    end
  end

end