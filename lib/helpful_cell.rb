class HelpfulCell < Cell::ViewModel
  include ActionView::RecordIdentifier
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::CaptureHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::RecordTagHelper
  include ActionView::Helpers::FormOptionsHelper
  include Hooks
  
  #require all helper modules
  Dir["#{File.dirname(__FILE__)}/../app/helpers/*.rb"].collect { |file| include File.basename(file).gsub(".rb", "").camelize.constantize }

  self.send :define_method, "get_user" do
    @user = controller.instance_variable_get("@user") rescue User.find(params[User.slug])
  end

  self.send :define_method, "get_parent" do
    if /_id/.match(params.keys.join(" "))
      parent = params.keys.collect{|key| /(.+)_id/.match(key)}.compact[0][1]
      instance_variable_set("@#{parent}", controller.instance_variable_get("@#{parent}"))
    end
  end

  self.send :define_method, "get_items" do
    instance_variable_set("@#{controller.controller_name}", controller.instance_variable_get("@#{controller.controller_name}"))
  end

  self.send :define_method, "get_item" do
    instance_variable_set("@#{controller.controller_name.singularize}", controller.instance_variable_get("@#{controller.controller_name.singularize}"))
  end

  define_hook :before_filter, :after_filter

  def call(state = :show, *args)
    run_hook :before_filter
    content = super
    run_hook :after_filter
    content.to_s
  end

  self.send :before_filter, :get_user
  self.send :before_filter, :get_parent
  self.send :before_filter, :get_items
  self.send :before_filter, :get_item

end