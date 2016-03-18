class PoolsController < ApplicationController

  before_filter only: [:create] do
    insist_on :logged_in
  end

  before_filter only: [:gallery] do
    insist_on :existence, @user
  end

  def after_save
    current_user.update_attribute(:attachments, current_user.attachments << "pool-#{@pool.id}")
  end

  def gallery
    redirect_to submissions_path(@user.gallery)
  end

  def before_update
    @pool.title = params[:pool][:title]
  end

  def set_default
    @user.attachments.delete("pool-#{params[Pool.slug]}")
    @user.attachments.unshift("pool-#{params[Pool.slug]}")
    respond_to do |format|
      if @user.save
        format.html { back }
        format.js { render "index" }
      else
        format.html { back_with_errors }
        format.js { back_with_errors_js }
      end
    end
  end

end
