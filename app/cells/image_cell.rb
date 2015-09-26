class ImageCell < Cell::ViewModel

  def show(options)
    #raise "break"
    @image = Upload.find(options[:id]) || Upload.new
    render locals: { type: options[:type], id: options[:id] }
  end

end
