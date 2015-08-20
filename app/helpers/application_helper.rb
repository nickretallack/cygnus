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

  def format_flash(message, key:)
    suffix = ""
    case key
    when "success"
      suffix = "!"
    when "danger", "info"
      suffix = "."
    end
    ("<span>"+message.capitalize+suffix+"</span>").html_safe
  end

  def show_errors?
    ["create"].include? params[:action]
  end

  def back_with_errors
    referer_params = Rails.application.routes.recognize_path request.referer
    setter(referer_params)
    render referer_params
  end

  def url_with_protocol(url)
    /^http:\/\/|^https:\/\//.match(url)? url : "http://" + url
  end

  def render_markdown(content)
    markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(escape: true, hard_wrap: true, prettify:true), autolink: true, tables: true)
    markdown.render(content).html_safe
  end

  def image_for(user: nil)
    case false
    when user.nil?
      user.upload.nil?? -1 : user.upload.id
    end
  end

  def level_of(level)
    CONFIG[:user_levels].index(level.to_s)
  end

  def at_least(grade)
    current_user.level >= level_of(grade)
  end

  def can_modify?(user: nil, id: nil)
    @can_modify ||= at_least(:admin) or current_user == (user || User.find[id])
  end

  def enum_for(*args)
    key, value = args.first.first
    if value.empty?
      concat "No "+key.to_s+" here yet."
    else
      value.each do |item|
        yield item
      end
    end
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
