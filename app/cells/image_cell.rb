class ImageCell < Cell::ViewModel

  def show(options)
    @model = Upload.find(options[:id]) || Upload.new
    html = image_tag(@parent_controller.image_path(options[:type], options[:id]))
    case options[:type].to_sym
    when :bordered
      className = "thumbnail "+(@model.explicit?? "danger" : "success")
      "<div class = '#{className}'>"+html+"</div>"
    when :full
      className = "image"
      "<div class = '#{className}'>"+html+"</div>"
    else
      html
    end
  end

end