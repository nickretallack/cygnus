class MessagesController < ApplicationController
  
  #include ActionController::Live

  before_filter only: [:create_announcement] do
    insist_on do
      at_least :admin
    end
  end

  before_filter only: [:listener, :poller] do
    insist_on :logged_in
  end

  before_filter only: [:index, :create] do
    if params[:reply_to_name]
      @reply_to = User.find(params[:reply_to_name])
      insist_on :existence, @reply_to
    end
  end

  before_filter only: [:create] do
    insist_on :logged_in
  end

  before_filter only: [:index, :update, :destroy] do
    insist_on :permission, @user
  end

  def create_announcement
    @new_message = Message.new
    
  end

  def new
    @submission = Submission.find(params[:submission])
    @reply_to = Message.find(params[:reply])
    send_data cell(:comment, @reply_to).(:new, params[:indent].to_i + 1)
  end

  def create
    case params[:commit].downcase
    when "comment"
      @submission = Submission.find(params[Submission.slug])
      @message = Message.new(content: params[:message][:content])
      respond_to do |format|
        if @message.save
          current_user.update_attribute(:attachments, current_user.attachments << "comment-#{@message.id}")
          if params["reply_#{Message.slug}"]
            @reply = Message.find(params["reply_#{Message.slug}"])
            @reply.update_attribute(:attachments, @reply.attachments << "comment-#{@message.id}")
          else
            @submission.update_attribute(:attachments, @submission.attachments << "comment-#{@message.id}")
          end
          format.html { back }
          format.js
        else
          format.html{ back_with_errors }
          format.js
        end
      end
    when "send"
      if @user == @reply_to
        flash[:danger] = "can't pm yourself"
        back
      else
        @message = Message.new(subject: params[:message][:subject], content: params[:message][:content])
        respond_to do |format|
          if @message.save
            if params["reply_#{Message.slug}"]
              @reply = Message.find(params["reply_#{Message.slug}"])
              @user.update_attribute(:attachments, @user.attachments << "pm-sent-#{@message.id}")
              @reply.update_attribute(:attachments, @reply.attachments << "pm-#{@message.id}")
            else
              @user.update_attribute(:attachments, @user.attachments << "pm-sent-#{@message.id}" << "pm-#{@message.id}")
              @reply_to.update_attribute(:attachments, @reply_to.attachments << "pm-#{@message.id}")
            end
            flash[:success] = "pm sent #{"to #{@reply_to.name}" if @reply_to}"
            format.html{ back }
            format.js
          else
            format.html{ back_with_errors }
            format.js
          end
        end
      end
    when "announce"
      @message = Message.new(subject: params[:message][:subject], content: params[:message][:content])
      if @message.save
        User.all.each do |user|
          user.update_attribute(:attachments, user.attachments << "announcement-#{@message.id}")
        end
        back
      else
        back_with_errors
      end
    end
  end

  def index
    if view_context.current_page? pms_path
      if @user == @reply_to
        render inline: cell(:pm).(:index), layout: :default
      else
        render inline: cell(:pm, @reply_to).(:new) + cell(:pm).(:index), layout: :default
      end
    elsif view_context.current_page? messages_path
      session[:toasts_seen] = current_user.unread_messages.length
      render inline: cell(:activity).(:index), layout: :default
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
    messages = current_user.unread_messages.drop(session[:toasts_seen]).map{ |message| message.content }
    session[:toasts_seen] += 1 if messages.any?
    send_data ActiveSupport::JSON.encode(messages.first)
  end

end
