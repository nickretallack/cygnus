module Generic
  extend ActiveSupport::Concern
  included do
    before_filter only: [:new, :show, :update, :destroy, :set_default, :accept, :reject, :fav] do
      unless instance_of? UsersController or instance_of? ImagesController
        set_item(klass.find(params[klass.slug]))
      end
    end

    before_filter :set_user

    before_filter only: [:show, :update, :destroy, :set_default, :accept, :reject, :fav] do
      unless instance_of? UsersController or instance_of? ImagesController
        unless item
          flash[:danger] = "#{klass_name} does not exist"
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
    end

    define_method :index do
      if user
        paginate user.send(controller_name)
      else
        paginate klass.all
      end
    end

    define_method :show do
    end

    define_method :before_save, proc{}

    define_method :after_save, proc{}

    define_method :create do
      before_save
      if item.save
        after_save
        success_routes("#{klass_name} created successfully")
      else
        danger_routes
      end
    end

    define_method :before_update, proc{}

    define_method :after_update, proc{}

    define_method :update do
      before_update
        if item.save
          after_update
          success_routes("#{klass_name} updated successfully")
        else
          danger_routes
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
      success_routes("#{klass_name} destroyed")
    end

    define_method :set_default do
      @user.attachments.delete("#{klass_name}-#{params[klass.slug]}")
      @user.attachments.unshift("#{klass_name}-#{params[klass.slug]}")
      @user.save(validate: false)
      success_routes("default #{klass_name} changed to #{title_for item}")
    end
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

  def klass_name
    controller_name.singularize
  end

  def item_string
    "@#{klass_name}"
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
end
