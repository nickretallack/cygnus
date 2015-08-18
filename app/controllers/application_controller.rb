class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper
	before_filter :make_safe_params_method, only: [:create, :update]

  self.send :define_method, "index", Proc.new {
    self.instance_variable_set("@"+controller_name, controller_name.classify.constantize.all.order(:id))
  }

  self.send :define_method, "show", Proc.new {
    klass = controller_name.classify.constantize
    self.instance_variable_set "@"+controller_name.singularize, (klass.find_by klass.slug => @referer_params.nil?? params[klass.slug] : @referer_params[klass.slug])
  }

  self.send :define_method, "new", Proc.new {
    self.instance_variable_set("@new_"+controller_name.singularize, controller_name.classify.constantize.new)
  }

  def make_safe_params_method
    name = controller_name.singularize
    self.class.send :define_method, name+"_params", Proc.new {
      params.require(name.to_sym).permit(send(name+"_params_permitted"))
    }
    self.class.send :private, name+"_params"
  end

  def activate_session(user)
    session[:user_id] = user.id
  end

  def deactivate_session
    session.delete(:user_id)
    @current_user = nil
  end
end
