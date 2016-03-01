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

  def referer_is(controller, action)
    route = Rails.application.routes.recognize_path(request.referer)
    route[:controller] == controller and route[:action] == action
  end

  def external_link(text, href)
    link_to text, (/^http:\/\//.match(href) ? href : "http://#{href}")
  end

  def paginate(results, limit = 20)
    results.offset(limit * (params[:page] || 1)).limit(limit) rescue ActiveRecord::Relation.new
  end

end