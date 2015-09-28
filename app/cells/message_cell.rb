class MessageCell < Cell::ViewModel
  include ActionView::RecordIdentifier
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::CaptureHelper

  def index
    #raise "break"
    #@parent_controller.response.headers["Content-Type"] = "text/event-stream"
    html = ""
    @model.each do |message|
      html += cell(:message, message).(:show)
    end
    html
  end

  def show(options = {})
    #raise "break"
    #@reply_path = @comments.nil?? new_pm_path(@user.name, @model.id) : new_comment_path(@submission.id, @model.id)
    @reply = "top"
    @reply = "reply-#{@model.message_id}" if @model.message_id
    @indent = options[:indent] || 0
    render
  end

  def new(options = {})
    @submission = @parent_controller.instance_variable_get("@submission")
    if @submission or options[:submission_id]
      @url = comments_path(options[:submission_id] || @submission.id)
      @content_placeholder = "Comment"
    else
      @url = #pms_path(current_user.name, defined?(recipient)? recipient
      @content_placeholder = "Message Body"
    end
    #@submit_text = defined?(message_id)? "Reply" : defined?(recipient)? "PM #{recipient}" : "Post as #{current_user.name}"
    @message_id = options[:message_id]
    render
  end

end
