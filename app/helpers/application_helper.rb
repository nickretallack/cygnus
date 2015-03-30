module ApplicationHelper
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
    if @current_user.nil?
        @current_user = AnonymousUser.new
    end
    @current_user
  end
  def logged_in?
    !current_user.nil?
  end

  def url_with_protocol(url)
    /^http/i.match(url) ? url : "http://#{url}"
  end

  def current_user_or_admin?(user)
    @current_user == user || @current_user.is_admin?
  end
  def render_markdown(content)
    markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(
	escape: true, hard_wrap: true, prettify:true), autolink: true, tables: true)
    markdown.render(content).html_safe
  end
end
