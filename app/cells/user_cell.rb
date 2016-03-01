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

  def page_nav
    
  end

end