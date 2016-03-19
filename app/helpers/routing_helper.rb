module RoutingHelper

  def back
    if request.referer
      redirect_to :back
    else
      redirect_to :root
    end
  end

  def root_js
    render js: "window.location.replace(#{root_path});"
  end

  def back_js
    if request.referer and Regexp.new(Regexp.escape(CONFIG[:host])).match(URI.parse(request.referer).host)
      render js: "location.reload();"
    else
      root_js
    end
  end

  def back_with_errors
    flash[:errors] = instance_variable_get("@#{controller_name.singularize}").errors.full_messages
    back
  end

  def back_with_errors_js
    flash[:errors] = instance_variable_get("@#{controller_name.singularize}").errors.full_messages
    back_js
  end

  def deny_access
    respond_to do |format|
      format.html { back }
      format.js { back_js }
    end
  end

  def shunt_to_root
    respond_to do |format|
      format.html{ redirect_to :root }
      format.js{ root_js }
    end
  end

  def success_routes(flash_message = nil)
    respond_to do |format|
      format.html{
        flash[:success] = flash_message if flash_message
        back
      }
      format.js
    end
  end

  def danger_routes
    respond_to do |format|
      format.html{ back_with_errors }
      format.js{ back_with_errors_js }
    end
  end

  def not_found
    flash[:danger] = "record not found"
    respond_to do |format|
      format.html { back }
      format.js { back_js }
    end
  end

  def referer_is(controller, action)
    route = Rails.application.routes.recognize_path(request.referer)
    route[:controller] == controller and route[:action] == action
  end

  def external_link(text, href)
    link_to text, (/^(http|https):\/\//.match(href) ? href : "http://#{href}")
  end

  def paginate(results, limit = nil)
    limit ||= controller_name.constantize.classify.results_per_page rescue 20
    instance_variable_set("@#{controller_name}", (results.offset(limit * (((params[:page] || "1").to_i) - 1)).limit(limit) rescue nil))
    instance_variable_set("@total_#{controller_name}", (results.count rescue nil))
  end

end