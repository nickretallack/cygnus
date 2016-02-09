class ImageCell < HelpfulCell

  def show(type, id = nil, suffix = "")
    @image = Upload.find(id) || Upload.new

    if @image.enabled?
      if @image.explicit? and not current_user.view_adult?
        image_tag(controller.image_path("image_adult#{suffix}".to_sym), id: id, class: "adult")
      else
        image_tag(controller.image_path(type, id: id))
      end
    else
      image_tag(controller.image_path("image_disabled#{suffix}".to_sym))
    end
  end

  def full(id)
    "<div class = 'image'>#{show(:full, id)}</div>"
  end

  def thumb(id)
    show(:thumb, id, "_thumb")
  end

  def bordered(id)
    "<div class = 'thumbnail #{@image.explicit?? 'danger' : 'success'}>#{show(:bordered, id, '_thumb')}</div>"
  end

end