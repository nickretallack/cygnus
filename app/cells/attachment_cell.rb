class AttachmentCell < Cell::ViewModel
  include ActionView::RecordIdentifier
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::CaptureHelper

  def show(options)
    @user = options[:user]
    @model ||= Attachment.new
    case options[:kind]
    when :image
      @upload = Upload.find(@model.attachment_id) || Upload.new
    end
    render options[:kind]
  end

end