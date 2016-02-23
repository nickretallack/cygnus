class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  #require all helper modules
  Dir["#{File.dirname(__FILE__)}/../helpers/*.rb"].collect { |file| include File.basename(file).gsub(".rb", "").camelize.constantize }

  before_filter :get_user

  before_filter only: [:show, :edit, :destroy, :update] do
    unless instance_of? UsersController or instance_of? ImagesController
      set_item(klass.find(params[klass.slug]))
    end
  end

  before_filter only: [:create] do
    set_item(klass.new)
  end

  define_method :index, proc{}

  define_method :show, proc{}

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
  
  define_method :destroy, proc{}

  def klass
    controller_name.classify.constantize
  end

  def item_string
    "@#{controller_name.singularize}"
  end

  def item
    instance_variable_get(item_string)
  end

  def set_item(value)
    instance_variable_set(item_string, value)
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
    render template: "pages/#{params[:page_name]}"
  end
end