class UserCell < HelpfulCell

  def header(action)
    case action
    when :index
      if params[:terms] == CONFIG[:default_search_terms]
        "Open Artists"
      else
        params[:terms][:tags]
      end
    end
  end

  def status(type)
    render "#{type}_status"
  end

end