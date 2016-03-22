class PoolsController < ApplicationController

  before_filter only: [:create] do
    insist_on :logged_in
  end

  before_filter only: [:gallery] do
    insist_on :existence, @user
  end

  def after_save
    @user.attachments << "pool-#{@pool.id}"
    @user.save(validate: false)
  end

  def gallery
    redirect_to submissions_path(@user.gallery)
  end

  def before_update
    @pool.title = params[:pool][:title]
  end

  def before_destroy
    @user.attachments.delete("pool-#{@pool.id}")
    @user.save(validate: false)
  end

end
