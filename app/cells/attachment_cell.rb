class AttachmentCell < Cell::ViewModel
  include ActionView::RecordIdentifier
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::CaptureHelper

  def new(options)
    @options = options
    render "new/#{options[:child_model]}"
  end

  def show
    render "show/#{@model.child_model}"
  end

end