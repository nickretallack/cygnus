class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user_or_admin,   only: [:edit, :update, :destroy]
  def index
    @users = User.paginate(page: params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @users, :except =>
	[:password_digest, :ip_Address]}
      format.json { render json: @users, :except =>
	[:password_digest, :ip_Address]}
    end
  end
  def search
    @users = User.search(params[:search][:search]).paginate(page: params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @users, :except =>
	[:password_digest, :ip_Address]}
      format.json { render json: @users, :except =>
	[:password_digest, :ip_Address]}
    end
  end
  def show
    @user = User.find_by name: params[:id]

    if @user.nil?
	 raise ActionController::RoutingError.new('Not Found')

    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render xml: @user, :except =>
	[:password_digest, :ip_Address]}
      format.json { render json: @user, :except =>
	[:password_digest, :ip_Address]}
    end
  end

  def destroy
    User.find_by(name: params[:id]).destroy
    flash[:warning] = "User deleted"
    redirect_to users_url
  end

  def edit
    @user = User.find_by name: params[:id]
    if @user.nil?
	 raise ActionController::RoutingError.new('Not Found')
    end
  end

  def update
    @user = User.find_by(name: params[:id])
    if(params[:user][:avatar_check] != '0') #checkboxes are hard to validate
    	@user.avatar = Upload.render(params[:user][:picture])
    end
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to action: "show", id: @user.name
    else
      render 'edit'
    end
  end

  def new
  @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.ip_Address = request.remote_ip
    @user.avatar = Upload.render(params[:user][:picture])
    if @user.save
      log_in @user
      flash[:success] = "Welcome to Bleatr!"
      redirect_to action: "show", id: @user.name
    else
      render 'new'
    end
  end

  def logon
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
      log_in user
      redirect_to :back
    else
	
      flash[:danger] = 'Invalid email/password combination'
      redirect_to :root
    end
  end

  def logout
    destroysession
    flash[:info] = "You have successfully logged out."
    redirect_to :root
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, :commissions, :tags,
                                   :trades, :requests, :price, :details, :gallery)
  end

  def logged_in_user
   #render :text => @current_user.name
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to :root
    end
  end
  def correct_user_or_admin
    @user = User.find_by(name: params[:id])
    unless current_user_or_admin?(@user)
      flash[:danger] = "Access Denied"
      redirect_to(root_url)
    end
  end
end
