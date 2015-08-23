class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper
  before_filter :setter
  helper_method :avatar_for
  helper_method :image_for

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

  def get_image
    @image ||= Upload.find(params[:id]) || Upload.new
  end

  def avatar_for(user, type = :thumb)
    image_for(type, id: user.avatar)
  end

  def image_for(type, id: nil)
    @image = Upload.find(id) || Upload.new
    if type == :bordered
      view_context.render inline: "<div id = 'flash' class = '"+(@image.explicit?? "danger" : "success")+"'><img src='"+image_path(type, id: id)+"'></div>".html_safe
    else
      view_context.render inline: "<img src='"+image_path(type, id: id)+"'>".html_safe
    end
  end
end
