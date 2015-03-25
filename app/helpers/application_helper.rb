module ApplicationHelper
  def current_user
    @current_user = @current_user || User.find_by(id: session[:user_id])
  end
  def logged_in?
    !current_user.nil?
  end
  def current_user_or_admin?(user)
    @current_user == user
  end
  def render_markdown(content)
    markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(
	escape: true, hard_wrap: true, prettify:true), autolink: true, tables: true)
    markdown.render(content).html_safe
  end
end
