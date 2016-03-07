class AttachmentCell < HelpfulCell

  def new_image(options = {})
    @model ||= Image.new
    @options = options
    render "new/image"
  end

end