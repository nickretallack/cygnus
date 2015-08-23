module ApplicationHelper
  def current_user
    @current_user ||= session[:username].nil?? AnonymousUser.new : User.find(session[:username])
  end

  def anon?
    current_user.instance_of? AnonymousUser
  end

  def current_user?(user)
    user == current_user
  end

  def format_flash(message, key)
    suffix = ""
    case key.to_sym
    when :success
      suffix = "!"
    when :danger, :info
      suffix = "."
    end
    ("<span>"+message.slice(0, 1).capitalize+message.slice(1..-1)+suffix+"</span>").html_safe
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

  def avatar_for(user, type = :thumb)
    image_for(type, id: user.avatar)
  end

  def image_for(type = :full, id: nil)
    @image = Upload.find(id) || Upload.new
    if type == :bordered
      render inline: "<div id = 'flash' class = '"+(@image.explicit?? "danger" : "success")+"'><img src='"+image_path(type, id: id)+"'></div>".html_safe
    else
      render inline: "<img src='"+image_path(type, id: id)+"'>".html_safe
    end
  end

  def at_least(grade)
    current_user.level >= User.level_for(grade)
  end

  def can_modify?(user: nil, id: nil)
    @can_modify ||= at_least(:admin) or current_user == user || User.find_by(id: id)
  end

  def insist_on(type, user: nil, id: nil)
    case type
    when :permission
      unless can_modify? user: user, id: id
        flash[:danger] = "you are not allowed to modify that record"
        redirect_to :back
      end
    when :existence
      unless user || user.find_by(id: id)
        flash[:danger] = "no such user"
        redirect_to :root
      end
    end
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
end
