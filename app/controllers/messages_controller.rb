class MessagesController < ApplicationController
  
  before_filter only: [:create, :new, :create_comment, :create_announcement, :poller, :listener] do
    insist_on :logged_in
  end

  before_filter only: [:index, :activity, :create_pm, :update] do
    insist_on :permission, @user
  end

  before_filter only: [:create_announcement] do
    insist_on do
      at_least? :admin
    end
  end

  before_filter only: [:listener, :poller] do
    insist_on :logged_in
  end

  before_filter only: [:index, :create_pm] do
    if params[:reply_to_name]
      @reply_to = User.find_slug(params[:reply_to_name])
      insist_on :existence, @reply_to
    end
  end

  before_filter only: [:create_pm] do
    if @user == @reply_to
      flash[:danger] = "can't pm yourself"
      respond_to do |format|
        format.html{ back }
        format.js{ back_js }
      end
    end
  end

  def new
    @submission = Submission.find(params[:submission])
    @reply_to = Message.find(params[:reply])
    send_data render "comment/_new", model: @reply_to, indent: params[:indent].to_i + 1
  end

  def create_comment
    @submission = Submission.find(params[Submission.slug])
    @message = Message.new(content: params[:message][:content])
    respond_to do |format|
      if @message.save
        current_user.update_attribute(:attachments, current_user.attachments << "comment-#{@message.id}")
        if params["reply_#{Message.slug}"]
          @reply = Message.find(params["reply_#{Message.slug}"])
          @reply.update_attribute(:attachments, @reply.attachments << "comment-#{@message.id}")
          @submission.update_attribute(:attachments, @submission.attachments << "buried_comment-#{@message.id}")
        else
          @submission.update_attribute(:attachments, @submission.attachments << "buried_comment-#{@message.id}" << "comment-#{@message.id}")
        end
        Message.comment current_user, @submission
        format.html { back }
        format.js { render "comments/create" }
      else
        format.html{ back_with_errors }
        format.js{ back_with_errors_js }
      end
    end
  end

  def create_pm
    @message = Message.new(subject: params[:message][:subject], content: params[:message][:content])
    respond_to do |format|
      if @message.save
        if params["reply_#{Message.slug}"]
          @reply = Message.find(params["reply_#{Message.slug}"])
          @user.update_attribute(:attachments, @user.attachments << "pm_sent-#{@message.id}" )
          @reply.update_attribute(:attachments, @reply.attachments << "pm-#{@message.id}")
          user = pm_partner(@reply.top)
          user.update_attribute(:attachments, user.attachments << "unread_pm-#{@message.id}")
        else
          @user.update_attribute(:attachments, @user.attachments << "pm_sent-#{@message.id}" << "pm-#{@message.id}")
          @reply_to.update_attribute(:attachments, @reply_to.attachments << "pm-#{@message.id}" << "unread_pm-#{@message.id}")
        end
        format.html{
          flash[:success] = "pm sent"
          back
        }
        format.js{ render "pms/create" }
      else
        format.html{ back_with_errors }
        format.js { back_with_errors_js }
      end
    end
  end

  def create_announcement
    @message = Message.new(subject: params[:message][:subject], content: params[:message][:content])
    respond_to do |format|
      if @message.save
        #Todo, make this not be a blackhole of database calls
        User.all.each do |user|
          user.update_attribute(:attachments, user.attachments << "announcement-#{@message.id}")
        end
        format.html{
          flash[:success] = "message created"
          back
        }
        format.js { render "announcements/create" }
      else
        format.html{ back_with_errors }
        format.js{ back_with_errors_js }
      end
    end
  end

  def index
    @title = "Conversations"
    @user.unread_pms.each do |pm|
      @user.attachments.delete("unread_pm-#{pm.id}")
      @user.attachments << "read_pm-#{pm.id}"
    end
    @user.save(validate: false)
    if @user == @reply_to
      flash[:danger] = "cannot pm yourself"
    end
    render "pms/index"
  end

  def activity
    @title = "Recent Activity"
    session[:toasts_seen] = current_user.unread_messages.length
    render "activity/index"
  end

  def listener #sse
    response.headers["Content-Type"] = "text/event-stream"
    sse = SSE.new(response.stream)
    begin
      Message.on_change do |id|
        sse.write(view_context.render("comments/_show", model: Message.find(id), indent: 0))
      end
    rescue IOError
    ensure
      sse.close
    end
    render nothing: true
  end

  def poller
    comments = []
    if params[:submission_id] != "-1"
      submission = Submission.find(params[:submission_id])
      difference = submission.all_comments.count - params[:comments].to_i
      if difference > 0
        comments = submission.all_comments.last(difference).map{ |comment| [view_context.render("comments/_show", model: comment, indent: 0), (comment.comment_parent.id rescue 0)] }
      end
    end
    pms = []
    difference = current_user.unread_pms.count - params[:pms].to_i
    if difference > 0
      pms = current_user.unread_pms.last(difference).map{ |pm| [view_context.render("pms/pm_message", model: pm), (pm.pm_parent.id rescue 0)] }
    end
    message = current_user.unread_messages.drop(session[:toasts_seen]).first
    if message
      message = view_context.render "activity/unread", {model: message }
      session[:toasts_seen] += 1
    end
    send_data ActiveSupport::JSON.encode({ activity: message, comments: comments, pms: pms })
  end

end