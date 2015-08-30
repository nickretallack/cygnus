class CommentsController < ApplicationController
  before_filter -> { insist_on :permission }, only: :destroy

  def create
    if @new_comment.save
      redirect_to @new_comment.submission, anchor: @new_comment.id
    else
      back_with_errors
    end
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params_permitted
      [:content, :user_id, :submission_id]
    end
end
