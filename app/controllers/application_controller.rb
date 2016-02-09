class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  #require all helper modules
  Dir["#{File.dirname(__FILE__)}/../helpers/*.rb"].collect { |file| include File.basename(file).gsub(".rb", "").camelize.constantize }

  before_filter :get_user

  before_filter only: [:create, :destroy] do
    insist_on :permission, @user
  end

  before_filter only: [:show, :destroy, :update] do
    unless instance_of? ImagesController
      klass = controller_name.classify.constantize
      instance_variable_set("@#{controller_name.singularize}", klass.find(params[klass.slug])) if klass != User and klass.slug
    end
  end

  before_filter only: [:create] do
    instance_variable_set("@#{controller_name.singularize}", controller_name.classify.constantize.new)
  end

  define_method :index, proc{}
  define_method :show, proc{}
  define_method :create do
    before_save if defined? "before_save"
    respond_to do |format|
      if instance_variable_get("@#{controller_name.singularize}").save
        after_save if defined? "after_save"
        format.html { back }
        format.js
      else
        back_with_errors
      end
    end
  end
  define_method :update, proc{}
  define_method :destroy, proc{}

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