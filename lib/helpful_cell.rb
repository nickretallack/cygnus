class HelpfulCell < Cell::ViewModel
  include ActionView::RecordIdentifier
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::CaptureHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::RecordTagHelper
  include Hooks
  
  #require all helper modules
  Dir["#{File.dirname(__FILE__)}/../app/helpers/*.rb"].collect { |file| include File.basename(file).gsub(".rb", "").camelize.constantize }

  #self.assets_prefix = Rails.application.config.assets.prefix
  #self.assets_environment = Rails.application.assets
  #self.digest_assets = Rails.application.config.assets[:digest]

  self.send :define_method, "get_user" do
    @user = User.find(params[User.slug])
  end

  define_hook :before_filter, :after_filter

  def call(state = :show, *args)
    run_hook :before_filter
    content = super
    run_hook :after_filter
    content.to_s
  end

  self.send :before_filter, :get_user
end