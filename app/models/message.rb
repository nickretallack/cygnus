class Message < ActiveRecord::Base
  belongs_to :submission
  belongs_to :user
  
  #based on the BLIP service
  #after_create :notify_added
  
  validates :content, format: { with: /\S+/, message: "was empty!" }
  
  def self.link_to title, url
    "<a href=#{url}>#{title || url}</a>"
  end

  def self.url
    Rails.application.routes.url_helpers
  end
  
  def pm_author
    parents("user", "pm_sent").first
  end

  def pm
    children("message", "pm").first
  end

  def pm_parent
    parents("message", "pm").first
  end

  def top
    if pm_parent
      pm_parent.top
    else
      self
    end
  end

  def comment_author
    parents("user", "comment").first
  end

  def comments
    children("message", "comment")
  end

  def comment_parent
    parents("message", "comment").first
  end

  def type
    attachments.first
  end

  def format
    content = self.content
    case (model.type.to_sym rescue "")
      when :status_change
       content = content.gsub(/(#{CONFIG[:activity_icons].keys.join("|")})/){ |match| "<span class = 'inline comm-#{match}'>#{match.gsub("_", " ")}</span>" }
    end
    content = content.gsub("\n", "<br />")
    "#{self.created_at}: #{content}".html_safe
  end

  def Message.on_change #sse
    Message.connection.execute "LISTEN messages"
    loop do
      Message.connection.raw_connection.wait_for_notify do |event, pid, message|
        yield message
      end
    end
  ensure
    Message.connection.execute "UNLISTEN messages"
  end
  
  def self.watch current_user, user
    return if current_user.setting(:disable_activity_feed)
    message = Message.create(content: "#{link_to current_user.name, url.user_path(current_user)} watched you", attachments: ["watch"])
    user.update_attribute(:attachments, user.attachments << "unread_message-#{message.id}")
  end
  
  def self.favorite current_user, submission
    return if current_user.setting(:disable_activity_feed)
    message = Message.create(content: "#{link_to current_user.name, url.user_path(current_user)} favorited your submission #{link_to submission.title, url.submission_path(submission.pool, submission)}'", attachments: ["fav"])
    submission.user.update_attribute(:attachments, submission.user.attachments << "unread_message-#{message.id}")    
  end
  
  def self.accept_order current_user, order
    return if current_user.setting(:disable_activity_feed) || order.patron.nil?      
    message= Message.create(content: "#{link_to current_user.name, url.user_path(current_user)} accepted your #{link_to "commission order", url.order_path(order)}", attachments: ["accept_order"])
    order.patron.update_attribute(:attachments, order.patron.attachments << "unread_message-#{message.id}")     
  end
  
  def self.reject_order current_user, order
    return if current_user.setting(:disable_activity_feed) || order.patron.nil?      
    message = Message.create(content: "#{link_to current_user.name, url.user_path(current_user)} rejected your #{link_to "commission order", url.order_path(order)}", attachments: ["reject_order"])
    order.patron.update_attribute(:attachments, order.patron.attachments << "unread_message-#{message.id}")       
  end
  
  def self.order user, order
    return if user.setting(:disable_activity_feed)
    message = Message.create(content: "#{order.name || link_to(user.name, url.user_path(user))} placed a commission order with you", attachments: ["order"])
    order.user.update_attribute(:attachments, order.user.attachments << "unread_message-#{message.id}")   
  end
  
  def self.submission watchers, submission
    watchers.each do |user|
      return if user.setting(:disable_activity_feed)
      message = Message.create(content: "#{link_to submission.user.name, url.user_path(submission.user)} just created or updated their submission, #{link_to submission.title, url.submission_path(submission.pool, submission)}", attachments: ["submission"])
      user.update_attribute(:attachments, user.attachments << "unread_message-#{message.id}")   
    end
  end
  def self.status_change current_user
    current_user.watched_by.each do |user|
      return if user.setting(:disable_activity_feed)
      content = "#{link_to current_user.name, url.user_path(current_user)} has updated their statuses to: "
      content << current_user.statuses.map.with_index{ |status, index| "#{CONFIG[:commission_icons].keys[index]}: <span class = \"inline comm-#{status}\">#{status}</span>" }.join("; ")
      message = Message.create(content: content, attachments: ["status_change"])
      user.update_attribute(:attachments, user.attachments << "unread_message-#{message.id}")   
    end
  end
    
  def self.comment current_user, submission
    return if current_user.setting(:disable_activity_feed)
    message = Message.create(content: "#{link_to current_user.name, url.user_path(current_user)} commented on your submission, \u201C#{link_to submission.title, url.submission_path(submission.pool, submission)}\u201D", attachments: ["watch"])
    submission.user.update_attribute(:attachments, submission.user.attachments << "unread_message-#{message.id}")
  end
  
  private

  def notify_added #sse
    Message.connection.execute "NOTIFY messages, '#{self.id}'"
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
      when :workboard_update #not implemented
        content = "#{link_to current_user.name, user_path(current_user)} updated the status of your commission order on their #{link_to "workboard", cards_path(current_user)}"
      when :print_order #not implemented
        content = "#{current_user.name} ordered a print of #{object.user.name}'s #{view_context.link_to "submission", submission_path(object)}."
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
