class UsersController < ApplicationController

  before_filter only: [:show, :watch, :update, :activate, :reset, :update_password] do
    insist_on :existence, @user
  end

  before_filter only: [:dashboard, :update, :destroy_attachment] do
    insist_on :permission, @user
  end

  before_filter only: [:watch] do
    insist_on :logged_in
  end

  before_filter only: [:request_reset, :send_reset, :reset, :update_password, :destroy, :create] do
    insist_on :logged_out
  end

  before_filter only: [:watch] do
    insist_on do
      can_watch? @user
    end
  end

  before_filter only: [:send_activation] do
    @user = User.find_by email: session[:email]
    insist_on :existence, @user
  end

  before_filter only: [:log_in] do
    @user = User.find params[:session][:name]
    insist_on :existence, @user
  end

  before_filter only: [:destroy] do
    @user = User.find_by(email: session[:email])
    insist_on :existence, @user
  end

  before_filter only: [:send_reset] do
    @user = User.find(params[:reset][User.slug]) || User.find_by(email: params[:reset][:email])
    insist_on :existence, @user
  end

  before_filter only: [:reset] do
    @user = User.find params[User.slug]
    unless @user and @user.at_least? :member
      flash[:danger] = "password reset not allowed on your account"
      redirect_to :root
    end
  end

  before_filter only: [:reset] do
    unless @user.authenticated? params[:token]
      flash[:danger] = "invalid reset link"
      redirect_to :root
    end
  end

  before_filter only: [:reset] do
    if @user.reset_expired?
      flash[:danger] = "password reset token has expired. Reset email resent automatically"
      render :send_reset
    end
  end

  def log_in
    if @user.authenticate params[:session][:password]
      activate_session @user
      flash[:success] = "logged in as #{@user.name}"
      back
    else
      flash[:danger] = "incorrect password"
      back
    end
  end

  def log_out
    deactivate_session
    flash[:info] = "logged out"
    if referer_is "orders", "new"
      back
    else
      redirect_to :root
    end
  end

  def send_activation
    if @user.authenticate(params[:user][:password])
      @user.send_activation_email
      flash[:success] = "activation email resent to #{@user.email}"
    else
      flash[:danger] = "incorrect password for #{@user.name}"
    end
    back
  end

  def activate
    if @user.at_level? :unactivated and @user.authenticated? params[:token]
      first_log_in @user
    else
      flash[:danger] = "invalid activation link"
    end
    redirect_to :root
  end

  def request_reset
    render inline: cell(:user).(:request_reset), layout: :default
  end

  def send_reset
    @user.send_reset_email
    flash[:info] = "email sent with password reset instructions"
    back
  end

  def reset
    render inline: cell(:user, @user).(:reset), layout: :default
  end

  def update_password
    if @user.update_attribute(:password, params[:user][:password])
      activate_session @user
      flash[:success] = "password has been reset"
      redirect_to user_path(@user)
    else
      back_with_errors
    end
  end

  def index
    session[:terms] = ->{
      if params[:terms]
        params[:terms]
      elsif !session[:terms]
        CONFIG[:default_search_terms]
      else
        session[:terms]
      end
    }.call
    params[:page] ||= 1
    session[:page] = params[:page]
    session[:terms] = params[:terms] if params[:terms]
    paginate User.search(session[:terms])
    if params[:page] != session[:page]
      redirect_to users_path(session[:page])
      return
    end
    render inline: cell(:user).(:index), layout: :default
  end

  def dashboard
    render inline: cell(:user).(:edit_dashboard), layout: :default
  end

  def create
    @user = User.new(params.require(:user).permit([:name, :email, :password, :password_confirmation]))
    @user.ip_address = request.remote_ip
    if CONFIG[:email_required]
      @user.level = :unactivated
      if @user.save
        session[:email] = @user.email
        @user.send_activation_email
        flash[:info] = "please check #{@user.email} to activate your account"
        back
      else
        back_with_errors
      end
    else
      @user.level = :member
      @user.activated_at = Time.zone.now
      if @user.save
        first_log_in @user
        back
      else
        back_with_errors
      end
    end
  end

  def show
    if can_modify? @user
      render inline: cell(:user, @user).(:edit_profile), layout: :default
    else
      render inline: cell(:user, @user).(:show_profile), layout: :default
    end
  end

  def update
    if /mark all/.match(params[:commit].downcase)
      @user.attachments.each do |attachment|
        if /^unread_message-/.match attachment
          @user.attachments.delete(attachment)
          @user.attachments = @user.attachments << "message-#{/(\d+)/.match(attachment)[1]}"
          session[:toasts_seen] -= 1
        end
      end
      @user.save(validate: false)
      respond_to do |format|
        format.html{
          flash[:success] = "marked as read"
          back
        }
        format.js{ render "activity/update" }
      end
    elsif /older messages/.match(params[:commit].downcase)
      @user.attachments.delete_if{ |attachment| /^message-/.match attachment }
      @user.save(validate: false)
      respond_to do |format|
        format.html{
          flash[:success] = "messages deleted"
          back
        }
        format.js{ render "activity/update" }
      end
    elsif params[:user][:settings].is_a? Hash
      @user.settings = params[:user][:settings]
      @user.save(validate: false)
      success_routes("settings saved")
    else
      update_image_attachment("avatar")
      @user.statuses = params[:user][:statuses].values
      @user.artist_types = params[:user][:artist_types].reject{ |key, type| type.blank? }.values
      @user.offsite_galleries = params[:user][:offsite_galleries].reject{ |key, gallery| gallery.blank? }.values
      @user.price = params[:user][:price]
      @user.tags = params[:user][:tags]
      @user.details = params[:user][:details]
      @user.save(validate: false)
      success_routes("profile updated")
    end
  end

  def destroy
    session.delete :email
    @user.destroy
    flash[:info] = "account deleted"
    back
  end

  def watch
    user = current_user
    if watching? @user
      user.watching.delete(@user.id)
    else
      user.watching << @user.id
    end
    user.save(validate: false)
    success_routes("you are now watching #{@user.name}")
  end

  def destroy_attachment
    @user.attachments.delete(params[:attachment])
    if /^unread_message-/.match(params[:attachment])
      @user.attachments << "message-#{/(\d+)/.match(params[:attachment])[1]}"
      session[:toasts_seen] -= 1
      @user.save(validate: false)
      render "activity/update.js"
    else
      @user.save(validate: false)
      render nothing: true
    end
  end

end