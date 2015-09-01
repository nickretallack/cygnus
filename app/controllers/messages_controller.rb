class MessagesController < ApplicationController
  before_filter -> { insist_on :logged_in }, only: [:create]
  before_filter -> { @user = User.find(params[User.slug]); insist_on :permission, @user }, only: [:index]
  before_filter -> { insist_on :permission }, only: [:update, :destroy]

  def index
    @messages = @user.messages
  end

  def create
    @new_message.user_id = User.find(params[:to]).id
    @new_message.sender_id = current_user.id
    if @new_message.save
      flash[:success] = "message sent"
      redirect_to :back
    else
      back_with_errors
    end
  end

  def update
    respond_to do |format|
      if @message.update(message_params)
        redirect_to :back
      else
        back_with_errors
      end
    end
  end

  def destroy
    @message.destroy
    redirect_to :back
  end

  private

  def message_params_permitted
    [:subject, :content]
  end
end
