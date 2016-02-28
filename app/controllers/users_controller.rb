class UsersController < ApplicationController
  
  before_filter :check_expiration, only: [:reset_return, :reset_return_confirm]

  before_filter only: [:show] do
    insist_on :existence, @user
  end

  before_filter only: [:dashboard, :update, :destroy] do
    insist_on :permission, @user
  end

  before_filter only: [:watch] do
    insist_on do
      can_watch? @user
    end
  end

  def index
    params[:terms] ||= CONFIG[:default_search_terms]
    @users = User.search(params[:terms])
  end

  def create
    if cell(:user).(:register).to_bool
      back
    else
      back_with_errors
    end
  end

  def update
    raise "break"
    @user.update_attribute(:settings, params[:user][:settings]) if params[:user][:settings].is_a? Hash and @user.settings != params[:user][:settings]
    back
    # @user.avatar = Upload.render(params[:user][:upload][:picture], params[:user][:upload][:explicit]) unless params[:user][:upload][:picture].nil?
    # @user.view_adult = true if params[:user][:upload][:explicit]
    # @old_statuses = @user.statuses
    # @user.statuses = params[:user][:statuses].values
    # @user.artist_type = params[:user][:artist_type].values[0].split(", ").uniq.join(", ")
    # if @user.update_attributes(params.require(:user).permit([:tags]))
    #   activity_message(:status_change, params[:user][:statuses]) if @old_statuses != @user.statuses
    #   flash[:success] = "profile updated"
    #   back
    # else
    #   back_with_errors
    # end
  end

  def destroy
    @user.destroy
    flash[:success] = "account deleted"
    redirect_to :root
  end

  def log_in
    if cell(:user).(:log_in).to_bool
      back
    else
      back
    end
  end

  def log_out
    deactivate_session
    flash[:info] = "logged out"
    redirect_to :root
  end

  def watch

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
    @user = User.find(params[User.slug])
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
    if @user
      if @user.authenticate(params[:user][:password])
        @user.send_activation_email
        flash[:success] = "activation email resent to #{@user.email}"
      else
        flash[:danger] = "incorrect password for #{@user.name}"
      end
      redirect_to action: :new
    else
      flash[:danger] = "could not find user"
      back
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

  def dashboard

  end

  private
  
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