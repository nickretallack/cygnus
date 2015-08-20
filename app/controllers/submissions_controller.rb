class SubmissionsController < ApplicationController
  def create
    @new_submission.file_id = Upload.render(params[:submission][:picture], @new_submission.adult)
    @new_submission.title = "Untitled" if @new_submission.title.blank?
    #raise "break"
    if @new_submission.pool.user == current_user
      if @new_submission.save
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
    else
      flash[:danger] = "You don't own that pool."
      redirect_to :back
    end
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

  private
    def set_submission
      @submission = Submission.find(params[:id])
    end

    def submission_params_permitted
      [:title, :adult, :file_id, :pool_id, :file]
    end
end
