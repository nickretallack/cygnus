class CommentsController < ApplicationController
  before_filter -> { insist_on :logged_in }, only: [:create]
  before_filter -> { insist_on :permission, @comment.user }, only: [:update, :destroy]

  def create
    @new_comment.user_id = current_user.id
    @new_comment.submission_id = params[:submission_id]
    @new_comment.recipient_id = User.find(params[:recipient_id])
    if @new_comment.save
      redirect_to :back
    else
      back_with_errors
    end
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)

      else
      end
    end
  end

  def index
    @comments = @submission.nil?? User.find(params[User.slug]).messages : @submission.comments
  end

  def show

  end

  def destroy
    @comment.destroy
    redirect_to :back
  end

  private

  def comment_params_permitted
    [:content]
  end
end
