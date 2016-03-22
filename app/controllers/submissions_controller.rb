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

  def before_update
    if /hide/.match params[:commit].downcase
      @submission.hidden = !@submission.hidden
    end
    if /save/.match params[:commit].downcase
      update_image_attachment("image")
      @submission.title = params[:submission][:title]
      @submission.description = params[:submission][:description]
    end
  end

  def before_delete
    @pool = @submission.pool
    @pool.attachments.delete("submission-#{@submission.id}")
    @pool.save(validate: false)
    @submission.all_comments.each do |comment|
      user = comment.comment_author
      user.attachments.delete("comment-#{comment.id}")
      user.save(validate: false)
    end
  end

  def fav
    user = current_user
    if faved? @submission
      user.favs.delete(@submission.id)
    else
      user.favs << @submission.id
    end
    user.save(validate: false)
    success_routes
  end

end
