class MessagesController < ApplicationController
  before_filter -> { insist_on :logged_in }, only: [:new, :create]
  before_filter -> { insist_on :permission, @message.user }, only: [:update, :destroy]
  before_filter only: [:inbox, :outbox] do
    @user = User.find(params[User.slug])
    insist_on :permission, @user
  end

  def create
    @new_message.user_id = current_user.id
    @new_message.submission_id = params[:submission_id]
    @new_message.recipient_id = ->(params) {
      if params[:recipient]
        User.find(params[:recipient]).id
      else
        params[:message][:recipient_id]
      end
    }.call(params)
    @new_message.content = view_context.sanitize(params[:message][:content])
    if @new_message.save
      redirect_to :back
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
    @user = User.find(params[User.slug])
    @messages = @user.messages
  end

  def destroy
    @message.destroy
    redirect_to :back
  end

  def inbox
    @recipient = params[:recipient]
    @pms = current_user.pms_received
    @header = "Inbox"
    @box_link = view_context.link_to "Switch to Outbox", outbox_path(@user.name, @recipient)
    render "index_pms"
  end

  def outbox
    @recipient = params[:recipient]
    @pms = current_user.pms_sent
    @header = "Outbox"
    @box_link = view_context.link_to "Switch to Inbox", inbox_path(@user.name, @recipient)
    render "index_pms"
  end

  def new
    @submission = Submission.find(params[:submission_id])
    @recipient = Message.find(params[:recipient_id]).user
    respond_to do |format|
      format.js
    end
  end

  private

  def message_params_permitted
    [:subject, :content, :recipient_id]
  end
end
