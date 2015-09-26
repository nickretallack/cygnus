class SubmissionsController < ApplicationController
  before_filter only: [:create] do
    @pool = Pool.find(params[:submission][:pool_id])
    unless @pool
      flash[:danger] = "you must specify a pool and own it, sorry. We see through your wily ways"
      back and return
    end
    @user = @pool.user
    insist_on :permission, @user
  end
  before_filter -> { insist_on :permission, @submission.pool.user }, only: [:update, :destroy]

  def create
	if params[:submission][:upload][:picture].blank?
		flash[:danger] = "you forgot to add an image"
		back and return
	end
    @new_submission.file_id = Upload.render(params[:submission][:upload][:picture], params[:submission][:upload][:explicit])
    if @new_submission.save
      @user.update_attribute(:view_adult, true) unless not params[:submission][:upload][:explicit] or @user.view_adult
      activity_message(:new_submission, @new_submission)
      back
    else
      back_with_errors
    end
  end

  def show
    @submission = Submission.find(params[Submission.slug])
    @comments = @submission.comments
    @picture = Upload.find(@submission.file_id)
  end

  def update
    if @submission.update(submission_params)
      @submission.update_attribute(:file_id, Upload.render(params[:submission][:upload][:picture], params[:submission][:upload][:explicit])) if params[:submission][:upload][:picture]
      @user.update_attribute(:view_adult, true) unless not params[:submission][:upload][:explicit] or @user.view_adult
      back
    else
      back_with_errors
    end
  end

  def destroy
    flash[:success] = "#{@submission.title} destroyed"
    @submission.destroy
    back
  end

  def fav
    if faved? @submission
      current_user.update_attribute(:favs, current_user.favs.delete_if { |id| id == @submission.id })
    else
      current_user.update_attribute(:favs, current_user.favs << @submission.id)
      activity_message(:fav, @submission)
    end
    respond_to do |format|
      format.html { back }
      format.js
    end
  end

  private

  def submission_params_permitted
    [:title, :description, :pool_id]
  end
end
