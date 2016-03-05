class ImageCell < HelpfulCell

  def show(type, id = nil, suffix = "")
    @image ||= Image.find(id) || Image.new

    if @image.enabled?
      if @image.explicit? and not current_user.setting(:view_adult)
        image_tag(controller.image_path("image_adult#{suffix}".to_sym), id: id, class: "adult")
      else
        image_tag(controller.image_path(type, id: id))
      end
    else
      image_tag(controller.image_path("image_disabled#{suffix}".to_sym))
    end
  end

  def full(id)
    show = show(:full, id)
    div_for @image, class: "image" do
      show
    end
  end

  def thumb(id)
    show(:thumb, id, "_thumb")
  end

  def bordered(id)
    show = show(:bordered, id, "_thumb")
    div_for @image, class: "thumbnail #{@image.explicit?? 'danger' : 'success'}" do
      show
    end
  end

  def limited(id)
    show = show(:limited, id)
    div_for @image, class: "image #{@image.explicit?? 'danger' : 'success'}" do
      show
    end
  end

end