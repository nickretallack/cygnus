class UserCell < HelpfulCell

  def header(options)
    case options[:action]
    when :index
      case true
      when search_defaults
        "Open Artists"
      when search_all
        "All Users"
      else
        params[:terms][:tags]
      end
    when :dashboard
      if at_least :admin
        "ADMIN DASHBOARD"
      else
        unless options[:sanitize]
          "#{link_to params[User.slug], user_path(params[User.slug])}'s settings"
        else
          "#{@user.name}'s settings"
        end
      end
    when :show
      @user.name
    end
  end

  def status(type)
    render "#{type}_status"
  end

  def navigation
    if controller.instance_variable_get("@no_menu")
      render "plain_navigation"
    else
      render
    end
  end

  def log_in
    user = User.find(params[:session][:name])
    if user
      if user.authenticate(params[:session][:password])
        controller.activate_session user
        controller.flash[:success] = "logged in as "+user.name
        true
      else
        controller.flash[:danger] = "incorrect password"
        false
      end
    else
      controller.flash[:danger] = "no such user"
      false
    end
  end

  def register
    @user = User.new(params.require(:user).permit([:name, :email, :password, :password_confirmation]))
    @user.ip_address = request.remote_ip
    if CONFIG[:email_required]
      @user.level = :unactivated
      if @user.save
        session[:email] = @user.email
        @user.send_activation_email
        flash[:info] = "please check #{@user.email} to activate your account"
        redirect_to register_path
      else
        controller.instance_variable_set("@user", @user)
        false
      end
    else
      @user.level = :member
      @user.activated_at = Time.zone.now
      if @user.save
        controller.first_log_in @user
        true
      else
        controller.instance_variable_set("@user", @user)
        false
      end
    end
  end

  ["summary", "links", "watch"].each do |method|
    define_method method do
      render method
    end
  end

  ["nav", "menu"].each do |method|
    define_method method do
      render "#{anon?? "anon" : "member"}/#{method}"
    end
  end

end