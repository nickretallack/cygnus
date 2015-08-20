class UsersController < ApplicationController
  # before_action :logged_in_user, only: [:edit, :update, :destroy] 
  # before_action :correct_user_or_admin, only: [:edit, :update, :destroy]
  # before_action :check_expiration, only: [:reset_return, :reset_return_confirm]
  # before_filter :set_user, only: [:activate, :show, :destroy, :edit, :update]
  
  # def index
  #   @users = User.all.order(:name)
  #   respond_to do |format|
  #     format.html
  #     format.xml  { render xml: @users, :except => [:password_digest, :ip_Address] }
  #     format.json { render json: @users, :except => [:password_digest, :ip_Address] }
  #   end
  # end

  def activate
    if @user && @user.level == CONFIG[:user_levels].index("unactivated") && @user.authenticated?(:activation, params[:activation])
      @user.update_attribute(:level, CONFIG[:user_levels].index("member"))
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
    @users = User.search(@query)
    respond_to do |format|
      format.html
      format.xml  { render xml: @users, except: [:password_digest, :ip_Address]}
      format.json { render json: @users, except: [:password_digest, :ip_Address]}
    end
  end

  # def show
  #   if @user.nil?
  #     raise ActionController::RoutingError.new('Not Found')
  #   end

  #   respond_to do |format|
  #     format.html
  #     format.xml  { render xml: @user, :except => [:password_digest, :ip_Address]}
  #     format.json { render json: @user, :except => [:password_digest, :ip_Address]}
  #   end
  # end

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

  def create
    @new_user.ip_Address = request.remote_ip
    @new_user.avatar = Upload.render(params[:user][:picture])
    @new_user.level = CONFIG[:user_levels].index("unactivated") unless CONFIG[:email_required]
    if @new_user.save
      if CONFIG[:email_required]
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
        Pool.new(title: "Gallery", user_id: @new_user.id).save!
        activate_session @new_user
        flash[:success] = "Welcome to Bleatr"
        redirect_to :back
    	  # if request.xhr?
    			# render :text=> user_path(@user)
    	  # else
      	# 	respond_to do |format|
      	# 		format.html { redirect_to user_path(@user) }
      	# 		format.json { render xml: @user, :except =>
      	# 		[:password_digest, :ip_Address], status: :created, location: @user }
      	# 		format.xml { render json: @user, :except =>
      	# 		[:password_digest, :ip_Address], status: :created, location: @user }	  
      	# 	end
    	  # end
      end
    else
      back_with_errors
  		# if request.xhr?
  		# 	render 'new', layout: false, status: 406
  		# else  
  		# 	render 'new'
  		# end
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
      redirect_to controller: "users", action: "show", name: @user.name
    else
      redirect_to :back
    end
  end

  def log_in
    user = User.find_by(name: params[:session][:name].downcase)
    if user
      if user.authenticate(params[:session][:password])
        activate_session user
        flash[:success] = "Logged in as "+user.name
        redirect_to :back
      else
        flash[:danger] = "Incorrect password"
        redirect_to :back
      end
    else
      flash[:danger] = "No such user"
      redirect_to :back
    end
  end

  def log_out
    deactivate_session
    flash[:info] = "Logged out"
    redirect_to :root
  end

  private

  def user_params_permitted
    [:name, :email, :password, :password_confirmation, :commissions, :tags, :trades, :requests, :price, :details, :gallery, :view_adult]
  end

  def reset_params
    params.require(:user).permit(:password, :password_confirmation)
  end
  
  def check_expiration
    @user = User.find params[:id]
    unless @user and @user.level > CONFIG[:user_levels].index("member") and @user.authenticated?(:activation, params[:activation])
        redirect_to root_url
    end
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired."
      redirect_to password_reset_path
    end
  end
end
