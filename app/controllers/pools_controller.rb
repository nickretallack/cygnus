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

  def before_destroy
    @pool.user.attachments.delete("pool-#{@pool.id}")
    @pool.user.save(validate: false)
  end

end
