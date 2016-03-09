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
        session["terms"]["tags"]
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

  def footer(options)
    render "footer/#{options[:action]}" rescue nil
  end

  def status(type)
    render "status/#{type}"
  end

  ["navigation", "show", "edit", "summary", "attributes", "links", "watch"].each do |method|
    define_method method do
      render method
    end
  end

  ["show_profile", "edit_profile"].each do |method|
    define_method method do
      render "#{method.split("_")[1]}/#{method.split("_")[0]}"
    end
  end

  ["nav", "menu"].each do |method|
    define_method method do
      render "#{anon?? "anon" : "member"}/#{method}"
    end
  end

end