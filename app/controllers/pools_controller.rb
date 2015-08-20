class PoolsController < ApplicationController

  def gallery
    @user = User.find_by(User.slug => params[User.slug])
    @pool = @user.galleries.order(:id).first
    @submissions = @pool.submissions
    render :show
  end

  def index
    if params[:user_id]
      @user = User.find(params[:user_id])
      @pools = Pool.where(user_id: @user) 
    else
      @pools = Pool.all
    end
  end

  # def show
  #   @pool = Pool.find(params[:id])
  #   if !current_user.is_anonymous? && current_user.view_adult
  #     @submissions = Submission.where(pool_id: @pool.id)
  #   else
  #     @submissions = Submission.where(pool_id: @pool.id, adult: false)
  #   end
  # end

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
