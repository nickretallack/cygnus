class HelpfulCell < Cell::ViewModel
    include ActionView::RecordIdentifier
    include ActionView::Helpers::FormHelper
    include ActionView::Helpers::UrlHelper
    include ActionView::Helpers::CaptureHelper
    
    #require all helper modules
    Dir["#{File.dirname(__FILE__)}/../helpers/*.rb"].collect { |file| include File.basename(file).gsub(".rb", "").split("_").collect { |part| part.capitalize }.join("").constantize }
end