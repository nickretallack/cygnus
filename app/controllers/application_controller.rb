class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper
  include MessagesHelper
  before_filter :setter

  def setter(referer_params = nil)
    action = referer_params.nil?? params[:action].to_sym : referer_params[:action].to_sym
    begin
      klass = controller_name.classify.constantize
    rescue
      return
    end
    #raise "break"
    self.instance_exec do
      case action
      when :index, :search
        self.instance_variable_set("@"+controller_name, klass.all.order(klass.slug))
      when :new
        self.instance_variable_set("@"+controller_name.singularize, klass.new)
      when :create
        self.instance_variable_set("@new_"+controller_name.singularize, klass.new(params.require(controller_name.singularize.to_sym).permit(send(controller_name.singularize+"_params_permitted"))))
      when :update
        self.instance_variable_set("@"+controller_name.singularize, klass.find(params[klass.slug]))
        self.class.send :define_method, controller_name.singularize+"_params" do
          params.require(controller_name.singularize.to_sym).permit(send(controller_name.singularize+"_params_permitted"))
        end
      else        
        self.instance_variable_set("@"+controller_name.singularize, klass.find(referer_params.nil?? params[klass.slug] : referer_params[klass.slug]))
      end
    end
  end

  def activate_session(user)
    session[:username] = user.name
  end

  def deactivate_session
    session.delete(:username)
    @current_user = nil
  end

  def static
    render template: "pages/#{params[:page_name]}"
  end
end

