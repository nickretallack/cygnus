module ApplicationHelper
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
    if @current_user.nil?
        @current_user = AnonymousUser.new
    end
    @current_user
  end
  def logged_in?
    !current_user.id.nil?
  end

  def url_with_protocol(url)
    /^http/i.match(url) ? url : "http://#{url}"
  end

  def current_user_or_mod?(user)
    @current_user == user || @current_user.is_admin?
  end
  def render_markdown(content)
    markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(
	escape: true, hard_wrap: true, prettify:true), autolink: true, tables: true)
    markdown.render(content).html_safe
  end
  

  
  def has_column?(column_name)
    controller_name.singularize.capitalize.constantize.column_names.include?(column_name)
  end
  

  
   def logged_in_user
   #render :text => @current_user.name
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to :root
    end
  end
  CONFIG["user_levels"].each do |name, value|
      normalized_name = name.downcase.gsub(/ /, "_")

      define_method("#{normalized_name}_only") do 
		unless current_user.level >= value
		  flash[:danger] = "Access Denied"
		  redirect_to :root
        end
      end
	  define_method("current_user_or_#{normalized_name}?") do |user|
		@current_user == user || @current_user.is_admin?
	  end
  end
  
  
end
