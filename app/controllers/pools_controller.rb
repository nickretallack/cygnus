class PoolsController < ApplicationController
  before_filter only: [:create] do
    @user = User.find(params[User.slug])
    insist_on :permission, @user
  end

  def index
    if params[User.slug]
      @user = User.find(params[User.slug])
      @pools = @user.pools
    else
      @pools = Pool.all
    end
  end

  def show
    @user = User.find(params[User.slug])
    @pool = Pool.find(params[Pool.slug])
    @pool = @user.pools.first if @user and not @pool
    not_found and return unless @pool
    @submissions = Submission.where(pool_id: @pool.id)
  end

  def create
    @new_pool.user_id = @user.id
    if @new_pool.save
      flash[:success] = "created a new pool for #{current_user.name} titled #{title_for pool: @new_pool}"
      back
    else
      back_with_errors
    end
  end

  def destroy
    @pool = Pool.find(params[:id])
    flash[:success] = "#{@pool.title} destroyed"
    @user = @pool.user
    @pool.destroy
    if @user.pools.any?
      flash[:danger] = "the first pool on your pools list has now become your main gallery"
    else
      flash[:danger] = "you now have no pools. You may create one at any time by visiting your pools page. The first one you create will be linked from artist searches as your main gallery"
    end
    back
  end

  private

  def pool_params_permitted
    [:title, :user_id]
  end
end
