class MessagesController < ApplicationController
  before_filter -> { insist_on :logged_in }, only: [:create]
  before_filter -> { insist_on :permission, @message.user }, only: [:update, :destroy]

  def create
    @new_message.user_id = current_user.id
    @new_message.submission_id = params[:submission_id]
    @new_message.recipient_id = User.find(params[:recipient_id])
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

  def show

  end

  def destroy
    @message.destroy
    redirect_to :back
  end

  private

  def message_params_permitted
    [:content]
  end
end
