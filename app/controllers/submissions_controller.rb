class SubmissionsController < ApplicationController
  before_action :set_submission, only: [:show, :edit, :update, :destroy]

  def index
    @submissions = Submission.all
  end

  def show
  end

  def new
    @submission = Submission.new
  end

  def edit
  end

  def create
    console
    @submission = Submission.new(submission_params)
    @submission.file_id = Upload.render(params[:submission][:picture], @submission.adult)
    if @submission.pool.user == current_user
      if @submission.save
        respond_to do |format|
          format.html { redirect_to @submission, notice: 'Submission Built!' }
          format.json { render :show, status: :created, location: @submission }
  		    format.xml { render :show, status: :created, location: @submission }
        end
      else
        respond_to do |format|
          format.html { render :new }
          format.json { render json: @submission.errors, status: :unprocessable_entity }
  		    format.xml { render json: @submission.errors, status: :unprocessable_entity }
        end
      end
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
      format.html { redirect_to submissions_url, notice: 'Submission was successfully destroyed.' }
      format.json { head :no_content }
      format.xml { head :no_content }
    end
  end

  private
    def set_submission
      @submission = Submission.find(params[:id])
    end

    def submission_params
      params.require(:submission).permit(:title, :adult, :file_id, :pool_id, :file)
    end
end
