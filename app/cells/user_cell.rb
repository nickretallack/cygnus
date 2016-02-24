class UserCell < HelpfulCell

  def header(options)
    case options[:action]
    when :index
      if params[:terms] == CONFIG[:default_search_terms]
        "Open Artists"
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

  def summary
    render
  end

  def links
    render
  end

  def watch
    render
  end

end