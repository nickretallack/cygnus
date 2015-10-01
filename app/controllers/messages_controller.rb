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
    recipient = User.find(params[:recipient])
    @new_message.recipient_id = recipient.id if recipient
    @new_message.content = params[:message][:content]
    if params[:message][:accept_text_reply] and params[:message][:content][/>>[^\s\D]+/]
      @new_message.message_id = params[:message][:content][/>>[^\s\D]+/].gsub(">>", "").to_i
      @new_message.content = @new_message.content.gsub(/>>[^\s\D]+\s*/, "")
    else
      @new_message.message_id = params[:message][:message_id]
    end
    @new_message.recipient_id = nil if @new_message.message_id or @new_message.submission_id
    @new_message.subject = view_context.sanitize(@new_message.subject)
    @new_message.content = view_context.sanitize(@new_message.content)
    if @new_message.save
      respond_to do |format|
        format.html { back }
        format.js
      end
    else
      respond_to do |format|
        format.html { back_with_errors }
        format.js
      end
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
    if view_context.current_page? messages_path
      @user = User.find(params[User.slug])
      @unread_messages = current_user.unread_messages
      @header = "#{view_context.link_to(params[User.slug], user_path(params[User.slug]))}'s Activity"
      @html = cell(:message, @user.messages.reverse).(:index, type: :stub, mark_read: (current_user? @user))
      current_user.update_attribute(:unread_messages, 0)
      session[:unread_messages] = 0
    else
      @header = "Conversations"
      @new = cell(:message).(:new, recipient: params[:recipient])
      @html = cell(:message, current_user.pms.where(message_id: nil)).(:index, type: :full)
    end
  end

  def destroy
    @message.destroy
    back
  end

  def listener #sse
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

  def poller
    if Message.where(submission_id: params[:submission_id]).count > params[:count].to_i
      @message = Message.where(submission_id: params[:submission_id]).last
      send_data ActiveSupport::JSON.encode({message: cell(:message, @message).(:show)})
    end
    activity_count = current_user.unread_messages - session[:unread_messages]
    if activity_count > 0
      session[:unread_messages] += 1
      send_data ActiveSupport::JSON.encode({message: cell(:message, Message.where(user_id: -1, recipient_id: current_user.id).order("id desc").limit(activity_count).reverse.first).(:stub), pollAgain: (activity_count-1 > 0)})
    end
    render nothing: true
  end

  private

  def message_params_permitted
    [:subject, :content, :recipient_id]
  end
end
