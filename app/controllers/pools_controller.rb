class PoolsController < ApplicationController

  def before_save
  end

  def after_save
    new_lookup(user: @user.id, pool: @pool.id)
  end

  def destroy
    @pool = Pool.find(params[:id])
    flash[:success] = "#{@pool.title} destroyed"
    @pool.destroy
    if @user.pools.any?
      flash[:danger] = "the first pool on your pools list (#{@user.pools.first.title}) has now become your main gallery"
    else
      flash[:danger] = "you now have no pools. You may create one at any time by visiting your pools page. The first one you create will be linked from artist searches as your main gallery"
    end
    back
  end
end
