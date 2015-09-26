class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :setter, except: [:show, :listener]

  #require all helper modules
   Dir["#{File.dirname(__FILE__)}/../helpers/*.rb"].collect { |file| include File.basename(file).gsub(".rb", "").split("_").collect { |part| part.capitalize }.join("").constantize }

  #setter
  #
  #intended to automatically assign all useful instance variables in controller instances across the board
  #does not yet work with nested resources
  #example for UsersController:
  #
  # on index: @users = User.all.order(User.slug)
  # on new: @user = User.new
  # on create: @new_user = User.new(user_params)
  #   user_params is created from an array of permitted params in the controller, e.g.
  #   def user_params_permitted
  #     [:name, :email, :password, :password_confirmation]
  #   end
  # on update: @user = User.find(params[User.slug])
  #   user_params is defined as
  #   params.require(:user).permit(user_params_permitted)
  # on all other actions: @user = User.find(params[User.slug])
  #
  #
  def setter
    begin
      klass = controller_name.classify.constantize
    rescue
      return
    end
    self.instance_exec do
      case params[:action].to_sym
      when :index
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
        self.instance_variable_set("@"+controller_name.singularize, klass.find(params[klass.slug]))
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