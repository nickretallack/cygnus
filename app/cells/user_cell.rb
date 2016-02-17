class UserCell < HelpfulCell

  def header(action)
    case action
    when :index
      if params[:terms] == CONFIG[:default_search_terms]
        "Open Artists"
      else
        params[:terms][:tags]
      end
      when :dashboard
        "#{link_to params[User.slug], user_path(params[User.slug])}'s dashboard"
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