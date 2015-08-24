class PoolsController < ApplicationController

  def index
    if params[User.slug]
      @user = User.find(params[User.slug])
      @pools = Pool.where(user_id: @user.id) 
    else
      @pools = Pool.all
    end
  end

  def show
    @user = User.find(params[User.slug])
    @pool = Pool.find(params[Pool.slug]) || @user.pools.first
    redirect_to :back unless @pool
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
    @pool = Pool.new(pool_params)

    if @pool.user == current_user
      respond_to do |format|
        if @pool.save
          format.html { redirect_to @pool, notice: 'Pool was successfully created.' }
          format.json { render :show, status: :created, location: @pool }
        else
          format.html { render :new }
          format.json { render json: @pool.errors, status: :unprocessable_entity }
        end
      end
    else
      flash[:danger] = "You cannot make a pool for another user."
      redirect_to :back
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
    @pool = Pool.find(params[:id])
    @pool.destroy
    respond_to do |format|
      format.html { redirect_to pools_url, notice: 'Pool was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_pool
      @pool = Pool.find(params[:id])
    end

    def pool_params
      params.require(:pool).permit(:title, :user_id)
    end
end
