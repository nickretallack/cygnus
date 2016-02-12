class UserCell < HelpfulCell

  def header(action)
    case action
    when :index
      controller.params[:terms] == CONFIG[:default_search_terms]? "Open Artists" : controller.params[:terms][:tags] || ""
    end
  end

end