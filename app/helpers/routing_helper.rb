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

  def back_with_errors_js
    flash[:errors] = instance_variable_get("@#{controller_name.singularize}").errors.full_messages
    render js: "location.reload();"
  end

  def referer_is(controller, action)
    route = Rails.application.routes.recognize_path(request.referer)
    route[:controller] == controller and route[:action] == action
  end

  def external_link(text, href)
    link_to text, (/^http:\/\//.match(href) ? href : "http://#{href}")
  end

  def paginate(results, limit = nil)
    limit ||= controller_name.constantize.classify.results_per_page rescue 20
    instance_variable_set("@#{controller_name}", (results.offset(limit * (((params[:page] || "1").to_i) - 1)).limit(limit) rescue nil))
    instance_variable_set("@total_#{controller_name}", (results.count rescue nil))
  end

end