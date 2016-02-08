class ImageCell < HelpfulCell

  def show(options)
    @image = Upload.find(options[:id]) || Upload.new
    render locals: { type: options[:type], id: options[:id] }
  end

end