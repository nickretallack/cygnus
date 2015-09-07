module ApplicationHelper
  def first_log_in(user)
    Pool.new(title: "Gallery", user_id: user.id).save!
    activate_session user
    flash[:success] = "welcome to "+CONFIG[:name]
  end

  def current_user
    @current_user ||= session[:username].nil?? AnonymousUser.new : User.find(session[:username]) || AnonymousUser.new
  end

  def anon?
    current_user.instance_of? AnonymousUser
  end

  def current_user?(user)
    user == current_user
  end

  def not_found
    raise ActionController::RoutingError.new("Not Found")
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
    referer_params[:messages] = instance_variable_get("@new_"+controller_name.singularize).errors.full_messages
    redirect_to referer_params
  end

  def render_markdown(content)
    markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(escape: true, hard_wrap: true, prettify:true), autolink: true, tables: true)
    markdown.render(content).html_safe
  end

  def avatar_for(user, type = :bordered)
    image_for(type, user.avatar)
  end

  def image_for(type = :full, id = nil)
    render template: "images/show", locals: { type: type, id: id }
  end

  def at_least(grade)
    current_user.level >= User.level_for(grade)
  end

  def can_modify?(user)
    @can_modify ||= at_least(:mod) or current_user? user
  end

  def can_watch?(user)
    @can_watch ||= at_least(:admin) or (not anon? and not current_user? user)
  end

  def watching? user
    current_user.watching.include? user.id
  end

  def insist_on(type = nil, user = nil)
    case type
    when :logged_in
      if anon?
        flash[:danger] = "please sign in first"
        redirect_to :back
      end
    when :permission
      unless can_modify? user
        flash[:danger] = "you are not allowed to modify that record"
        redirect_to :back
      end
    when :existence
      unless user
        flash[:danger] = "no such user"
        redirect_to :root
      end
    else
      unless Proc.new.call
        flash[:danger] = "you do not have permission to do that"
        redirect_to :back
      end
    end
  end

  def enum_for(collection, word = nil)
    if collection.empty?
      if word.nil?
        concat "Nothing here."
      else
        concat "No #{word} yet."
      end
    else
      collection.each do |item|
        yield item
      end
    end
  end

  def message_for(*args)
    key, value = args.first.first
    key = key.to_s.gsub("_", " ").pluralize
    if value.blank?
      "No #{key} specified."
    else
      value
    end
  end

  def title_for(*args)
    key, value = args.first.first
    if value.title.blank?
      "Untitled #{key.to_s.gsub("_", " ").titleize}"
    else
      value.title
    end
  end

  def sanitize_title(content)
    sanitize(content, tags: []).gsub("&#39;", "'").titleize
  end
end
