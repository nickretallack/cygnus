class SubmissionsController < ApplicationController
  before_filter -> { insist_on :permission, User.find_by(id: Pool.find(params[:submission][:pool_id]).user_id) }, only: [:create]
  before_filter -> { insist_on :permission, @submission.pool.user }, only: [:update, :destroy]

  def create
	if params[:submission][:picture].blank?
		flash[:danger] = "you forgot to add an image"
		return redirect_to :back
	end
    @new_submission.file_id = Upload.render(params[:submission][:picture], @new_submission.adult)
    @new_submission.title = "Untitled" if @new_submission.title.blank?
    if @new_submission.save
      activity_message(:new_submission, @new_submission)
      redirect_to :back
    else
      back_with_errors
    end
    # respond_to do |format|
    #   if @submission.save
    #     format.html { redirect_to :back, notice: 'Submission Built!' }
    #     format.json { render :show, status: :created, location: @submission }
		  #   format.xml { render :show, status: :created, location: @submission }
    #   else
    #     format.html { redirect_to :back, notice: "Please choose a file." }
    #     format.json { render json: @submission.errors, status: :unprocessable_entity }
		  #   format.xml { render json: @submission.errors, status: :unprocessable_entity }
    #   end
      # end
  end

  def show
    @comments = @submission.comments
  end

  def update
    respond_to do |format|
      if @submission.update(submission_params)
        format.html { redirect_to @submission, notice: 'Submission updated!' }
        format.json { render :show, status: :ok, location: @submission }
		format.xml { render :show, status: :ok, location: @submission }
      else
        format.html { render :edit }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
		
        format.xml { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @submission.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Submission was successfully destroyed.' }
      format.json { head :no_content }
      format.xml { head :no_content }
    end
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
    [:title, :adult, :file_id, :pool_id, :file]
  end
end
