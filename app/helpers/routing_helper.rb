module RoutingHelper

  def back
    if request.referer
      redirect_to :back
    else
      redirect_to :root
    end
  end

  def not_found
    flash[:danger] = "record not found"
    back
  end

  def back_with_errors
    flash[:errors] = instance_variable_get("@#{controller_name.singularize}").errors.full_messages
    back
  end

end