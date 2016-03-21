class MessagesController < ApplicationController
  
  #include ActionController::Live

  before_filter only: [:create, :new, :create_comment, :create_announcement, :poller, :listener] do
    insist_on :logged_in
  end

  before_filter only: [:index, :activity, :create_pm, :update] do
    insist_on :permission, @user
  end

  before_filter only: [:new, :create_comment] do
    @submission = Submission.find(params[Submission.slug])
    unless @submission
      flash[:danger] = "submission #{params[Submission.slug]} not exist"
      back
    end
  end

  before_filter only: [:new, :create_comment] do
    route = Rails.application.routes.recognize_path(request.referer)
    unless route[:controller] == "submission" and route[:action] == "show" and route["submission_#{Submission.slug}"] == @submission.id
      flash[:danger] = "can only comment on a submission from its own page"
      back
    end
  end

  before_filter only: [:create_pm] do
    unless referer_is "messages", "index"
      flash[:danger] = "can only send a pm from your conversations page"
      back
    end
  end

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

  def new
    @submission = Submission.find(params[:submission])
    @reply_to = Message.find(params[:reply])
    send_data cell(:comment, @reply_to).(:new, params[:indent].to_i + 1)
  end

  def create_comment
    @submission = Submission.find(params[Submission.slug])
    @comment = Message.new(content: params[:message][:content])
    respond_to do |format|
      if @comment.save
        current_user.update_attribute(:attachments, current_user.attachments << "comment-#{@comment.id}")
        if params["reply_#{Message.slug}"]
          @reply = Message.find(params["reply_#{Message.slug}"])
          @reply.update_attribute(:attachments, @reply.attachments << "comment-#{@comment.id}")
          @submission.update_attribute(:attachments, @submission.attachments << "buried_comment-#{@comment.id}")
        else
          @submission.update_attribute(:attachments, @submission.attachments << "buried_comment-#{@comment.id}" << "comment-#{@comment.id}")
        end
        format.html { back }
        format.js { render "comments/create" }
      else
        format.html{ back_with_errors }
        format.js{ back_with_errors_js }
      end
    end
  end

  def create_pm
    if @user == @reply_to
      flash[:danger] = "can't pm yourself"
      back
    else
      @message = Message.new(subject: params[:message][:subject], content: params[:message][:content])
      respond_to do |format|
        if @message.save
          if params["reply_#{Message.slug}"]
            @reply = Message.find(params["reply_#{Message.slug}"])
            @user.update_attribute(:attachments, @user.attachments << "pm_sent-#{@message.id}" )
            @reply.update_attribute(:attachments, @reply.attachments << "pm-#{@message.id}")
            @reply.recipient.update_attribute(:attachments, @reply.recipient.attachments << "unread_pm-#{@message.id}") if @reply.recipient != @user
          else
            @user.update_attribute(:attachments, @user.attachments << "pm_sent-#{@message.id}" << "pm-#{@message.id}")
            @reply_to.update_attribute(:attachments, @reply_to.attachments << "pm-#{@message.id}" << "unread_pm-#{@message.id}")
          end
          format.html{
            flash[:success] = "pm sent #{"to #{@reply_to.name}" if @reply_to}"
            back
          }
          format.js{ render "pms/create" }
        else
          format.html{ back_with_errors }
          format.js { back_with_errors_js }
        end
      end
    end
  end

  def create_announcement
    @message = Message.new(subject: params[:message][:subject], content: params[:message][:content])
    respond_to do |format|
      if @message.save
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
    if @user == @reply_to
      flash[:danger] = "cannot pm yourself"
      render inline: cell(:pm).(:index), layout: :default
    elsif @reply_to
      render inline: cell(:pm, @reply_to).(:new) + cell(:pm).(:index), layout: :default
    else
      render inline: cell(:pm).(:index), layout: :default
    end
  end

  def activity
    session[:toasts_seen] = current_user.unread_messages.length
    render inline: cell(:activity).(:index), layout: :default
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
    comments = []
    if params[:submission_id] != "-1"
      submission = Submission.find(params[:submission_id])
      difference = submission.all_comments.count - params[:comments].to_i
      if difference > 0
        comments = submission.all_comments.last(difference).map{ |comment| [cell(:comment, comment).(:show, 0), (comment.comment_parent.id rescue 0)] }
      end
    end
    pms = []
    difference = current_user.unread_pms.count - params[:pms].to_i
    if difference > 0
      pms = current_user.unread_pms.last(difference).map{ |pm| [cell(:pm, pm).(:summary), cell(:pm, pm).(:show), (pm.pm_parent.id rescue 0)] }
    end
    messages = current_user.unread_messages.drop(session[:toasts_seen]).map{ |message| message.content }
    session[:toasts_seen] += 1 if messages.any?
    send_data ActiveSupport::JSON.encode({ activity: messages.first, comments: comments, pms: pms })
  end

end