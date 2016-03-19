class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  #require all helper modules
  Dir["#{File.dirname(__FILE__)}/../helpers/*.rb"].collect { |file| include File.basename(file).gsub(".rb", "").camelize.constantize }

  before_filter only: [:create, :update, :destroy, :set_default, :accept, :reject] do
    insist_on :referer
  end

  before_filter only: [:new, :show, :update, :destroy, :set_default, :accept, :reject, :fav] do
    unless instance_of? UsersController or instance_of? ImagesController
      set_item(klass.find(params[klass.slug]))
    end
  end

  before_filter :set_user

  before_filter only: [:show, :update, :destroy, :set_default, :accept, :reject, :fav] do
    unless instance_of? UsersController or instance_of? ImagesController
      unless item
        flash[:danger] = "#{cell_name} does not exist"
        deny_access
      end
    end
  end

  before_filter only: [:create] do
    unless instance_of? UsersController or instance_of? OrdersController
      insist_on :logged_in
    end
  end

  before_filter only: [:create] do
    unless instance_of? UsersController or instance_of? OrdersController
      unless user and can_modify? user
        instance_variable_set("@user", current_user)
      end
    end
  end

  before_filter only: [:update, :destroy, :set_default, :set_default, :accept, :reject] do
    insist_on :permission, user
  end

  before_filter only: [:index, :create, :show] do
    if /_id/.match(params.keys.join(" "))
      parent = params.keys.collect{|key| /(.+)_id/.match(key)}.compact[0][1]
      instance_variable_set("@#{parent}", (parent.classify.constantize.find(params["#{parent}_id"]) rescue nil))
      unless user
        instance_variable_set("@user", (instance_variable_get("@#{parent}").user rescue nil))
      end
    end
  end

  before_filter only: [:create] do
    set_item(klass.new)
  end

  define_method :new do
    render inline: cell(cell_name).(:new), layout: :default
  end

  define_method :index do
    if user
      paginate user.send(controller_name)
    else
      paginate klass.all
    end
    render inline: cell(cell_name).(:index), layout: :default
  end

  define_method :show do
    render inline: cell(cell_name, item).(:show), layout: :default
  end

  define_method :before_save, proc{}

  define_method :after_save, proc{}

  define_method :create do
    before_save
    respond_to do |format|
      if item.save
        after_save
        format.html { back }
        format.js
      else
        format.html { back_with_errors }
        format.js { back_with_errors_js }
      end
    end
  end

  define_method :before_update, proc{}

  define_method :after_update, proc{}

  define_method :update do
    before_update
    respond_to do |format|
      if item.save
        after_update
        format.html { back }
        format.js
      else
        format.html { back_with_errors }
        format.js { back_with_errors_js }
      end
    end
  end

  define_method :update_image_attachment do |word|
    if params[:image][:image]
      item.attachments.delete_if{ |attachment| attachment.split("-")[0] == word }
      item.attachments << "#{word}-#{Image.render(params[:image][:image], params[:image][:explicit])}"
      item.update_attribute(:attachments, item.attachments)
    elsif item.send word
      item.send(word).update_attribute(:explicit, params[:image][:explicit])
    end
    if params[:image][:explicit] and not setting(:view_adult)
      @user = (user || item.user)
      @user.settings[:view_adult] = "1"
      @user.save(validate: false)
    end
  end

  define_method :before_destroy, proc{}

  define_method :destroy do
    before_destroy
    item.destroy
    success_routes("#{cell_name} destroyed")
  end

  define_method :set_default do
    @user.attachments.delete("#{cell_name}-#{params[klass.slug]}")
    @user.attachments.unshift("#{cell_name}-#{params[klass.slug]}")
    @user.save(validate: false)
    success_routes("default #{cell_name} changed to #{title_for item}")
  end

  def klass
    controller_name.classify.constantize
  end

  def set_user
    instance_variable_set("@user", User.find(params[User.slug]) || item.user) rescue nil
  end

  def user
    instance_variable_get("@user")
  end

  def cell_name
    controller_name.singularize
  end

  def item_string
    "@#{cell_name}"
  end

  def item
    instance_variable_get(item_string)
  end

  def set_item(value)
    instance_variable_set(item_string, value)
  end

  def items_string
    "@#{controller_name}"
  end

  def items
    instance_variable_get(items_string)
  end

  def set_items(value)
    instance_variable_set(items_string, value)
  end

  def set_total(value)
    instance_variable_set("@total_#{controller_name}", value)
  end

  def activate_session(user)
    session[:username] = user.name
    session[:toasts_seen] = current_user.unread_messages.length
  end

  def deactivate_session
    session.delete(:username)
    @current_user = nil
  end

  def static
    render inline: cell(:application).(params[:page_name]), layout: :default
  end
end