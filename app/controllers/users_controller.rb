class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy] 
  before_action :correct_user_or_admin, only: [:edit, :update, :destroy]
  before_action :check_expiration, only: [:reset_return, :reset_return_confirm]
  before_filter :set_user, only: [:activate, :show, :destroy, :edit, :update, :correct_user_or_admin, :check_expiration]
  
  def index
    @users = User.paginate(page: params[:page]).includes(:upload)
    respond_to do |format|
      format.html
      format.xml  { render xml: @users, :except => [:password_digest, :ip_Address] }
      format.json { render json: @users, :except => [:password_digest, :ip_Address] }
    end
  end
  def activate
    if @user && @user.level == CONFIG["user_levels"]["Unactivated"] && @user.authenticated?(:activation, params[:activation])
      @user.update_attribute(:level, CONFIG["user_levels"]["Member"])
      @user.update_attribute(:activated_at, Time.zone.now)
      log_in @user
      flash[:success] = "Account activated!"
      redirect_to action: "show", id: @user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end

  def search
    @query = params[:search]? params[:search][:search] : ""
    @users = User.search(@query).paginate(page: params[:page]).includes(:upload)
    respond_to do |format|
      format.html
      format.xml  { render xml: @users, except: [:password_digest, :ip_Address]}
      format.json { render json: @users, except: [:password_digest, :ip_Address]}
    end
  end

  def show
    if @user.nil?
      raise ActionController::RoutingError.new('Not Found')
    end

    respond_to do |format|
      format.html
      format.xml  { render xml: @user, :except => [:password_digest, :ip_Address]}
      format.json { render json: @user, :except => [:password_digest, :ip_Address]}
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: params[:name] + 'has deactivated their account' }
      format.json { head :no_content }
      format.xml { head :no_content }
    end
  end

  def edit
    if @user.nil?
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def update
    @user.avatar = Upload.render(params[:user][:picture]) unless params[:user][:picture].nil?
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
  	  if request.xhr?
  			render :text=> user_path(@user)
  	  else  
    		respond_to do |format|
    			format.html { redirect_to user_path(@user) }
    			format.json { render xml: @user, :except =>
    			[:password_digest, :ip_Address], status: :ok, location: @user }
    			format.xml { render json: @user, :except =>
    			[:password_digest, :ip_Address], status: :ok, location: @user }
    		end
      end	
    else
  		if request.xhr?
  			render 'edit', layout: false, status: 406
  		else  
  			respond_to do |format|
  			    format.html { render :edit }
  				format.json { render json: @user.errors, status: :unprocessable_entity }
  				format.xml { render json: @user.errors, status: :unprocessable_entity }
  			end
  		end	
    end
  end

  def new
  @user = User.new
  
  end

  def create
    @user = User.new(user_params)
    @user.ip_Address = request.remote_ip
    @user.avatar = Upload.render(params[:user][:picture])
    @user.level = CONFIG["user_levels"]["Unactivated"] if !CONFIG["Email_Required"]
    if @user.save
      if CONFIG["Email_Required"]
        UserMailer.account_activation(@user).deliver_now
        flash[:info] = "Please check your email to activate your account."
    	  if request.xhr?
    			render :text=> root_url
    	  else
      		respond_to do |format|
      			format.html { redirect_to root_url }
      			format.json { render xml: @user, :except =>
      			[:password_digest, :ip_Address], status: :check_email, location: @user }
      			format.xml { render json: @user, :except =>
      			[:password_digest, :ip_Address], status: :check_email, location: @user }	  
      		end
    	  end
      else
        Pool.new(title: "Gallery", user_id: @user.id).save!
        log_in @user
        flash[:success] = "Welcome to Bleatr!"
    	  if request.xhr?
    			render :text=> user_path(@user)
    	  else
      		respond_to do |format|
      			format.html { redirect_to user_path(@user) }
      			format.json { render xml: @user, :except =>
      			[:password_digest, :ip_Address], status: :created, location: @user }
      			format.xml { render json: @user, :except =>
      			[:password_digest, :ip_Address], status: :created, location: @user }	  
      		end
    	  end
      end
    else
  		if request.xhr?
  			render 'new', layout: false, status: 406
  		else  
  			render 'new'
  		end
    end
  end

  def reset_confirm
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      UserMailer.password_reset(@user).deliver_now

      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'reset'
    end
  end
  def reset_return
      
  end
  def reset_return_confirm
    if params[:user][:password].blank?
      flash[:danger] = "Password can't be blank"
      redirect_to :back
    elsif @user.update_attributes(reset_params)
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to controller: "users", action: "show", name: @user
    else
      redirect_to :back
    end
  end

  def logon
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
      log_in user
      redirect_to :back
    else
	
      flash[:danger] = "Invalid email/password combination"
      redirect_to :back
    end
  end

  def logout
    destroysession
    flash[:info] = "You have successfully logged out."
    redirect_to :back
  end

  private

  def set_user
    @user = User.find params[:id]
  end

  def user_params
    params.require(:user).permit(:name, :email, :password,
                :password_confirmation, :commissions, :tags, :trades, :requests, :price, :details, :gallery)
  end
  def reset_params
    params.require(:user).permit(:password, :password_confirmation)
  end
  def correct_user_or_admin
    unless current_user_or_admin?(@user)
      flash[:danger] = "Access Denied"
      redirect_to(root_url)
    end
  end
  def check_expiration
    unless (@user && @user.level > CONFIG["user_levels"]["Member"] && @user.authenticated?(:activation, params[:activation]))
        redirect_to root_url
    end
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired."
      redirect_to password_reset_path
    end
  end
end
