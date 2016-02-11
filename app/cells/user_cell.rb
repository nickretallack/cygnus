class UserCell < HelpfulCell

  def header(action)
    case action
    when :index
      if controller.instance_variable_get("@searching")
        controller.instance_variable_get("@query")
      else
        "Open Artists"
      end
    end
  end

end