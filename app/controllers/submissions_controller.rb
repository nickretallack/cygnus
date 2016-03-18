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
    insist_on :permission, @submission.users
  end

  before_filter only: [:fav] do
    insist_on do
      can_fav? @submission
    end
  end

  def index
    if @pool
      if can_modify? @pool.user
        paginate @pool.submissions
      else
        paginate @pool.submissions.where(hidden: false)
      end
    else
      paginate Submission.where(hidden: false)
    end
    render inline: cell(:submission).(:index), layout: :default
  end

  def after_save
    @pool.update_attribute(:attachments, @pool.attachments << "submission-#{@submission.id}")
  end

  def show
    if @pool
      if can_modify? @pool.user
        render inline: cell(:submission, @submission).(:edit), layout: :default
      else
        render inline: cell(:submission, @submission).(:show), layout: :default
      end
    else
      if can_modify? @submission.pool.user
        render inline: cell(:submission, @submission).(:edit), layout: :default
      else
        render inline: cell(:submission, @submission).(:show), layout: :default
      end
    end
  end

  def update
    if /hide/.match params[:commit].downcase
      @submission.hidden = !@submission.hidden
    end
    if /save/.match params[:commit].downcase
      update_image_attachment("image")
      @submission.title = params[:submission][:title]
      @submission.description = params[:submission][:description]
    end
    respond_to do |format|
      if @submission.save
        format.html{
          flash[:success] = "submission updated"
          back
        }
        format.js
      else
        format.html { back_with_errors }
        format.js { back_with_errors_js }
      end
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

end
