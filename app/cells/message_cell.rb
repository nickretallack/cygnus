class MessageCell < HelpfulCell

  def index(options = {})
    #raise "break"
    #@parent_controller.response.headers["Content-Type"] = "text/event-stream"

    html = ""
    @model.each do |message|
      html += cell(:message, message).(options[:type])
    end
    #@parent_controller.current_user.update_attribute(:unread_messages, 0) if options[:mark_read]
    html
  end

  def full(options = {})
    #raise "break"
    #@reply_path = @comments.nil?? new_pm_path(@user.name, @model.id) : new_comment_path(@submission.id, @model.id)
    if @parent_controller.current_user == @model.user
      @background = "sent"
    else
      @background = "received"
    end
    @reply = "reply-#{@model.message_id}" if @model.message_id
    @indent = options[:indent] || 0
    render
  end

  def stub
    if @parent_controller.instance_variable_get("@unread_messages")
      @unread = @parent_controller.instance_variable_get("@unread_messages") > 0
      @parent_controller.instance_variable_set("@unread_messages", @parent_controller.instance_variable_get("@unread_messages")-1)
    else
      @unread = true
    end
    render
  end

  def new(options = {})
    @submission = @parent_controller.instance_variable_get("@submission")
    if @submission or options[:submission_id]
      @url = comments_path(options[:submission_id] || @submission.id)
      @content_placeholder = "Comment"
    else
      @recipient = options[:recipient]
      @url = pms_path(current_user.name, @recipient)
      @subject = true
      @content_placeholder = "Message Body"
    end
    @submit_text = "Post as #{current_user.name}"
    @message_id = options[:message_id]
    render
  end

  def new_announcement
    render
  end

end
