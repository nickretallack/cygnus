class UsersController < ApplicationController
  before_filter :check_expiration, only: [:reset_return, :reset_return_confirm]
  before_filter -> { insist_on :existence, @user }, only: [:show]
  before_filter -> { insist_on :permission, @user }, only: [:update, :destroy]
  before_filter -> {
    insist_on do
      can_watch? @user
    end
  }, only: [:watch]

  def index
    # handles search; if we are just indexing, @users is already set
    if params[:terms]
      @query = params[:terms][:tags]
      @status = params[:terms][:status]
      @users = User.search(params[:terms])
      @searching = true
    end
  end

  def create
    @new_user.ip_address = request.remote_ip
    @new_user.avatar = Upload.render(params[:user][:picture])
    @new_user.level = ->(email_required) {
      if email_required
        :unactivated
      else
        :member
      end
    }.call(CONFIG[:email_required])
    if @new_user.save
      if CONFIG[:email_required]
        session[:email] = @new_user.email
        @new_user.send_activation_email
        flash[:info] = "please check #{@new_user.email} to activate your account"
        redirect_to action: :new
      else
        first_log_in @new_user
        back
      end
    else
      back_with_errors
    end
  end

  def update
    #raise "break"
    @user.avatar = Upload.render(params[:user][:upload][:picture], params[:user][:upload][:explicit]) unless params[:user][:upload][:picture].nil?
    @user.view_adult = true if params[:user][:upload][:explicit]
    @user.statuses = params[:user][:statuses].values
    if @user.update_attributes(user_params)
      @user.update_attribute(:view_adult, true) unless not params[:user][:upload][:explicit] or @user.view_adult
      @user.update_attribute(:artist_type, @user.artist_type + "#{", " unless @user.artist_type.blank?}" + format_artist_type(params[:user][:artist_types].values)) if params[:user][:artist_types].values[0].to_i > -1
      flash[:success] = "profile updated"
      back
    else
      back_with_errors
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "account deleted"
    redirect_to :root
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

  def watch
    #raise "break"
    if watching? @user
      current_user.update_attribute(:watching, current_user.watching.delete_if { |id| id == @user.id })
    else
      current_user.update_attribute(:watching, current_user.watching << @user.id)
      activity_message(:watch, @user)
    end
    respond_to do |format|
      format.html { back }
      format.js
    end
  end

  def activate
    if @user and @user.at_level :unactivated and @user.authenticated? :activation, params[:activation]
      @user.update_attribute(:level, :member)
      @user.update_attribute(:activated_at, Time.zone.now)
      first_log_in @user
      redirect_to action: :show, User.slug => @user
    else
      flash[:danger] = "invalid activation link"
      back
    end
  end

  def resend_activation_email
    @user = User.find_by(email: session[:email])
    if @user.authenticate(params[:user][:password])
      @user.send_activation_email
      flash[:success] = "activation email resent to #{session[:email]}"
    else
      flash[:danger] = "incorrect password for @user.name"
    end
    redirect_to action: :new
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

  private

  def user_params_permitted
    [:name, :email, :password, :password_confirmation, :tags, :price, :details, :gallery, :view_adult, :artist_type]
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
