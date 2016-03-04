class SubmissionsController < ApplicationController
  
  before_filter only: [:create] do
    unless @pool
      flash[:danger] = "pool does not exist"
      back
    end
  end

  before_filter only: [:create] do
    insist_on :permission, @pool.users
  end

  before_filter only: [:update, :destroy] do
    insist_on :permission, @submission.pool.users
  end

  before_filter only: [:fav] do
    insist_on do
      can_fav? @submission
    end
  end

  def after_save
    @pool.update_attribute(:attachments, @pool.attachments << "submission-#{@submission.id}")
  end

  def update
    if @submission.update(submission_params)
      # activity_message(:new_submission, @new_submission)
      @submission.update_attribute(:file_id, Upload.render(params[:submission][:upload][:picture], params[:submission][:upload][:explicit])) if params[:submission][:upload][:picture]
      @submission.pool.user.update_attribute(:view_adult, true) unless not params[:submission][:upload][:explicit] or @submission.pool.user.view_adult
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

end
