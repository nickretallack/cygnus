class MessagesController < ApplicationController
  include ActionController::Live
  before_filter -> { insist_on :logged_in }, only: [:new, :create, :index, :index_pms]
  before_filter -> { insist_on :permission, @message.user }, only: [:update, :destroy]
  before_filter only: [:index_pms] do
    @user = User.find(params[User.slug])
    insist_on :permission, @user
  end

  def create
    @new_message.user_id = current_user.id
    @new_message.submission_id = params[:submission_id]
    @new_message.recipient_id = params[:recipient_id]
    @new_message.message_id = params[:message][:message_id]
    @new_message.content = view_context.sanitize(params[:message][:content])
    if @new_message.save
      respond_to do |format|
        format.js
      end
    else
      back_with_errors
    end
  end

  def update
    respond_to do |format|
      if @message.update(message_params)

      else
      end
    end
  end

  def index
    raise "break"
    @user = User.find(params[User.slug])
    if view_context.current_page? messages_path
      @messages = @user.messages
    elsif view_context.current_page? submission_path
      @comments = @submission.comments
    else
      @pms = current_user.pms_received + current_user.pms_sent
      @recipient = params[:recipient]
    end
  end

  def destroy
    @message.destroy
    back
  end

  def listener
    response.headers["Content-Type"] = "text/event-stream"
    sse = SSE.new(response.stream)
    begin
      Message.on_change do |id|
        sse.write(cell(:message, Message.find(id)).(:show))
      end
    rescue IOError
    ensure
      sse.close
    end
    render nothing: true
  end

  private

  def message_params_permitted
    [:subject, :content, :recipient_id]
  end
end
