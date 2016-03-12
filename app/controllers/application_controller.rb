class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  #require all helper modules
  Dir["#{File.dirname(__FILE__)}/../helpers/*.rb"].collect { |file| include File.basename(file).gsub(".rb", "").camelize.constantize }

  before_filter :get_user

  before_filter only: [:show, :update, :destroy] do
    unless instance_of? UsersController or instance_of? ImagesController
      set_item(klass.find(params[klass.slug]))
    end
  end

  before_filter only: [:show, :update, :destroy] do
    unless instance_of? UsersController or instance_of? ImagesController
      unless item
        flash[:danger] = "#{cell_name} does not exist"
        back
      end
    end
  end

  before_filter only: [:index, :create, :show] do
    if /_id/.match(params.keys.join(" "))
      parent = params.keys.collect{|key| /(.+)_id/.match(key)}.compact[0][1]
      instance_variable_set("@#{parent}", (parent.classify.constantize.find(params["#{parent}_id"]) rescue nil))
    end
  end

  before_filter only: [:create] do
    set_item(klass.new)
  end

  define_method :index do
    if user
      set_items(paginate user.send(controller_name), klass.results_per_page) rescue nil
      set_total(user.send(controller_name).count) rescue nil
    else
      set_items(paginate klass.all, klass.results_per_page) rescue nil
      set_total(klass.all.count) rescue nil
    end
    render inline: cell(cell_name).(:index), layout: :default
  end

  define_method :show do
    render inline: cell(cell_name, item).(:show), layout: :default
  end

  define_method :edit, proc{}

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
        back_with_errors
      end
    end
  end
  
  define_method :update, proc{}

  define_method :update_image_attachment do |word|
    if params[:image][:image]
      item.attachments.delete_if{ |attachment| attachment.split("-")[0] == word }
      item.attachments << "#{word}-#{Image.render(params[:image][:image], params[:image][:explicit])}"
      item.update_attribute(:attachments, item.attachments)
    elsif item.send word
      item.send(word).update_attribute(:explicit, params[:image][:explicit])
    end
  end
  
  define_method :destroy, proc{}

  def klass
    controller_name.classify.constantize
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
    session[:unread_messages] = current_user.unread_messages
  end

  def deactivate_session
    session.delete(:username)
    @current_user = nil
  end

  def static
    render inline: cell(:application).(params[:page_name]), layout: :default
  end
end