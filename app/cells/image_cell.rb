class ImageCell < HelpfulCell

  def show(type, id = nil, suffix = "")
    @image ||= Image.find(id) || Image.new

    if @image.enabled?
      if @image.explicit? and not current_user.setting(:view_adult)
        image_tag(controller.image_path("image_adult#{suffix}".to_sym))
      else
        image_tag(controller.image_path(type, id: id))
      end
    else
      image_tag(controller.image_path("image_disabled#{suffix}".to_sym))
    end
  end

  def full(id)
    show = show(:full, id)
    div_for @image, class: "full #{@image.explicit?? 'danger' : 'success'} #{"adult" if @image.explicit? and not current_user.setting(:view_adult)}" do
      show
    end
  end

  def limited(id)
    show = show(:limited, id)
    div_for @image, class: "limited #{@image.explicit?? 'danger' : 'success'} #{"adult" if @image.explicit? and not current_user.setting(:view_adult)}" do
      show
    end
  end

  def medium(id)
    show = show(:medium, id)
    div_for @image, class: "medium #{@image.explicit?? 'danger' : 'success'} #{"adult" if @image.explicit? and not current_user.setting(:view_adult)}" do
      show
    end
  end

  def bordered(id)
    show = show(:bordered, id, "_thumb")
    div_for @image, class: "bordered #{@image.explicit?? 'danger' : 'success'} #{"adult" if @image.explicit? and not current_user.setting(:view_adult)}" do
      show
    end
  end

end