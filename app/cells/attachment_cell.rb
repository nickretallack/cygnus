class AssociationCell < HelpfulCell
  def new(options)
    @options = options
    render "new/#{options[:child_model]}"
  end

  def show
    render "show/#{@model.child_model}"
  end

end