class UsersController < ApplicationController
  before_filter :check_expiration, only: [:reset_return, :reset_return_confirm]
  #before_filter -> { insist_on :existence, user: @user }, only: [:show]
  before_filter -> { insist_on :permission, user: @user }, only: [:update, :destroy]
  
  # def index
  #   @users = User.all.order(:name)
  #   respond_to do |format|
  #     format.html
  #     format.xml  { render xml: @users, :except => [:password_digest, :ip_Address] }
  #     format.json { render json: @users, :except => [:password_digest, :ip_Address] }
  #   end
  # end

  # def index
  #   raise "break"
  # end

  def activate
    if @user and @user.at_level :unactivated and @user.authenticated? :activation, params[:activation]
      @user.update_attribute(:level, User.level_for(:member))
      @user.update_attribute(:activated_at, Time.zone.now)
      activate_session @user
      flash[:success] = "account activated!"
      redirect_to action: :show, User.slug => @user
    else
      flash[:danger] = "invalid activation link"
      redirect_to :root
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

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: params[:name] + "has deactivated their account" }
      format.json { head :no_content }
      format.xml { head :no_content }
    end
  end

  def update
    @user.update_attribute(:avatar, Upload.render(params[:user][:upload][:picture])) unless params[:user][:upload][:picture].nil?
    Upload.find(@user.avatar).update_attribute(:explicit, params[:user][:upload][:explicit]) unless @user.avatar.nil?
    if @user.update_attributes(user_params)
      flash[:success] = "profile updated"
      redirect_to :back
  	  # if request.xhr?
  			# render :text=> user_path(@user)
  	  # else  
    	# 	respond_to do |format|
    	# 		format.html { redirect_to user_path(@user) }
    	# 		format.json { render xml: @user, :except =>
    	# 		[:password_digest, :ip_Address], status: :ok, location: @user }
    	# 		format.xml { render json: @user, :except =>
    	# 		[:password_digest, :ip_Address], status: :ok, location: @user }
    	# 	end
     #  end	
    else
      back_with_errors
  		# if request.xhr?
  		# 	render 'edit', layout: false, status: 406
  		# else  
  		# 	respond_to do |format|
  		# 	  format.html { render :edit }
  		# 		format.json { render json: @user.errors, status: :unprocessable_entity }
  		# 		format.xml { render json: @user.errors, status: :unprocessable_entity }
  		# 	end
  		# end	
    end
  end

  def create
    @new_user.ip_Address = request.remote_ip
    @new_user.avatar = Upload.render(params[:user][:picture])
    @new_user.level = User.level_for :unactivated unless CONFIG[:email_required]
    if @new_user.save
      if CONFIG[:email_required]
        UserMailer.account_activation(@user).deliver_now
        flash[:info] = "please check your email to activate your account."
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
        flash[:success] = "welcome to "+CONFIG[:name]
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

      flash[:info] = "email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "email address not found"
      render 'reset'
    end
  end
  def reset_return
      
  end
  def reset_return_confirm
    if params[:user][:password].blank?
      flash[:danger] = "password can't be blank"
      redirect_to :back
    elsif @user.update_attributes(reset_params)
      log_in @user
      flash[:success] = "password has been reset"
      redirect_to controller: "users", action: "show", name: @user.name
    else
      redirect_to :back
    end
  end

  def log_in
    user = User.find(params[:session][:name])
    if user
      if user.authenticate(params[:session][:password])
        activate_session user
        flash[:success] = "logged in as "+user.name
        redirect_to :back
      else
        flash[:danger] = "incorrect password"
        redirect_to :back
      end
    else
      flash[:danger] = "no such user"
      redirect_to :back
    end
  end

  def log_out
    deactivate_session
    flash[:info] = "logged out"
    redirect_to :back
  end

  private

  def user_params_permitted
    [:name, :email, :password, :password_confirmation, :commissions, :tags, :trades, :requests, :price, :details, :gallery, :view_adult]
  end

  def reset_params
    params.require(:user).permit(:password, :password_confirmation)
  end
  
  def check_expiration
    @user = User.find_by id: params[:id]
    unless @user and @user.level > CONFIG[:user_levels].index("member") and @user.authenticated?(:activation, params[:activation])
      redirect_to root_url
    end
    if @user.password_reset_expired?
      flash[:danger] = "password reset has expired"
      redirect_to password_reset_path
    end
  end
end
