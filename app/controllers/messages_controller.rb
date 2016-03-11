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

  before_filter only: [:index, :create, :update, :destroy] do
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
    end
  end

  def index
    if /conversations/.match url_for(params)
      if @user == @reply_to
        render inline: cell(:pm).(:index), layout: :default
      else
        render inline: cell(:pm, @reply_to).(:new) + cell(:pm).(:index), layout: :default
      end
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
      send_data ActiveSupport::JSON.encode({message: cell(:message, Message.where("user_id = -1 AND ? = ANY (recipient_ids)", current_user.id).order("id desc").limit(activity_count).reverse.first).(:stub), pollAgain: (activity_count-1 > 0)})
    else
      render nothing: true
    end
  end

end
