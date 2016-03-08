class PoolsController < ApplicationController

  before_filter only: [:create] do
    insist_on :logged_in
  end

  def after_save
    current_user.update_attribute(:attachments, current_user.attachments << "pool-#{@pool.id}")
  end

  def index
    if @user
      @total_pools = @user.pools.count
      @pools = paginate @user.pools, Pool.results_per_page
    else
      @total_pools = Pool.all.count
      @pools = paginate Pool.all, Pool.results_per_page
    end
  end

  def gallery
    @pool = @user.gallery
    render inline: cell(:pool, @pool).(:show), layout: :default
  end

  def destroy
    @pool = Pool.find(params[:id])
    flash[:success] = "#{title_for @pool} destroyed"
    @pool.destroy
    back
  end

  def update
    @pool.update_attributes(params.require(:pool).permit([:title]))
    back
  end
end
