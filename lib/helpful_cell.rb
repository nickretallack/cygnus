require "hooks"

class HelpfulCell < Cell::ViewModel
    include ActionView::RecordIdentifier
    include ActionView::Helpers::FormHelper
    include ActionView::Helpers::UrlHelper
    include Hooks
    
    #require all helper modules
    Dir["#{File.dirname(__FILE__)}/../app/helpers/*.rb"].collect { |file| include File.basename(file).gsub(".rb", "").camelize.constantize }

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