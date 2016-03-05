class AttachmentCell < HelpfulCell

  def new_image(explicit: false)
    @explicit = explicit
    render "new/image"
  end

end