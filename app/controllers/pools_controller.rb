class PoolsController < ApplicationController

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

  def new
    @pool = Pool.new
    @pool.user = current_user
  end

  def edit
    @pool = Pool.find(params[:id])
    @user = @pool.user
  end

  def create
    @new_pool.user_id = current_user.id #we don't trust the outside world
    respond_to do |format|
      if @new_pool.save
        format.html { redirect_to @new_pool, notice: 'Pool was successfully created.' }
        format.json { render :show, status: :created, location: @new_pool }
      else
        format.html { render :new }
        format.json { render json: @new_pool.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @pool = Pool.find(params[:id])
    respond_to do |format|
      if @pool.update(pool_params)
        format.html { redirect_to @pool, notice: 'Pool was successfully updated.' }
        format.json { render :show, status: :ok, location: @pool }
      else
        format.html { render :edit }
        format.json { render json: @pool.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    raise "break"
    @pool = Pool.find(params[:id])
    @pool.destroy
    respond_to do |format|
      format.html { redirect_to pools_url, notice: 'Pool was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def pool_params_permitted
    [:title, :user_id]
  end
end
