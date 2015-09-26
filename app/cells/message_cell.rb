class MessageCell < Cell::ViewModel

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
    @indent = options[:indent] || 0
    render
  end

end
