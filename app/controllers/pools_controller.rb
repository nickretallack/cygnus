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
    @user = @pool.user
    @user.attachments.delete("pool-#{params[Pool.slug]}")
    @user.attachments.unshift("pool-#{params[Pool.slug]}")
    @user.save(validate: false)
    respond_to do |format|
      format.html{
        flash[:success] = "Your default pool is now #{title_for @pool}"
        back
      }
      format.js
    end
  end

  def before_destroy
    @pool.user.attachments.delete("pool-#{@pool.id}")
    @pool.user.save(validate: false)
  end

end
