class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper
	before_filter :make_safe_params_method, only: [:create, :update]
  before_filter :make_setter, only: [:activate, :destroy, :edit, :update]
  before_filter :make_new, only: [:create]

  def make_setter
    klass = controller_name.classify.constantize
    variable = controller_name.singularize
    self.singleton_class.send :define_method, "set_"+variable, Proc.new {
      self.instance_variable_set("@"+variable, klass.find_by(klass.slug => params[klass.slug]))
    }
    self.send ("set_"+variable).to_sym
    self.singleton_class.send :private, ("set_"+variable).to_sym
  end

  def make_safe_params_method
    name = controller_name.singularize
    self.class.send :define_method, name+"_params", Proc.new {
      params.require(name.to_sym).permit(send(name+"_params_permitted"))
    }
    self.class.send :private, name+"_params"
  end

  def make_new
    klass = controller_name.classify.constantize
    name = controller_name.singularize
    variable = "new_"+name
    self.singleton_class.send :define_method, "set_"+variable, Proc.new {
      self.instance_variable_set("@"+variable, klass.new(self.send((name+"_params").to_sym)))
    }
    self.send ("set_"+variable).to_sym
    self.singleton_class.send :private, ("set_"+variable).to_sym
  end

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

  def activate_session(user)
    session[:user_id] = user.id
  end

  def deactivate_session
    session.delete(:user_id)
    @current_user = nil
  end
end
