module ApplicationHelper
  def current_user
    @current_user ||= session[:user_id].nil?? AnonymousUser.new : User.find(session[:user_id])
  end

  def anon?
    current_user.instance_of? AnonymousUser
  end

  def current_user?(user)
    user == current_user
  end

  def flappelation(name)
    case name
    when "success"
      "!"
    when "danger", "info"
      "."
    end
  end

  def show_errors?
    params[:action] == "create"
  end

  def back_with_errors
    referer_params = Rails.application.routes.recognize_path request.referer
    obj = (referer_params[:controller].camelize+"Controller").constantize.new
    obj.instance_variable_set "@referer_params", referer_params
    variable_name = (referer_params[:action] == "index")? referer_params[:controller] : referer_params[:controller].singularize
    instance_variable_set "@"+variable_name, obj.send(referer_params[:action])
    render referer_params
  end

  def url_with_protocol(url)
    /^http:\/\/|^https:\/\//.match(url)? url : "http://" + url
  end

  def render_markdown(content)
    markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(escape: true, hard_wrap: true, prettify:true), autolink: true, tables: true)
    markdown.render(content).html_safe
  end
  
  # def logged_in_user
  #   #render :text => @current_user.name
  #   unless logged_in?
  #     flash[:danger] = "Please log in."
  #     redirect_to :root
  #   end
  # end
  
  # CONFIG[:user_levels].each do |name|
  #   normalized_name = name.downcase.gsub(/ /, "_")

  #   define_method("#{normalized_name}_only") do 
		#   unless current_user.level >= CONFIG[:user_levels].index(name)
		#     flash[:danger] = "Access Denied"
		#     redirect_to :root
  #     end
  #   end

	 #  define_method("current_user_or_#{normalized_name}?") do |user|
		#   @current_user == user or @current_user.is_admin?
	 #  end
  # end
end
