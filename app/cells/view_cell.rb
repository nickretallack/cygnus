class ViewCell < HelpfulCell

  def hidable(options)
    @title = options[:title] || ""
    @content = options[:content] || ""
    @open = options[:open] || false
    @associated = options[:associated]
    render
  end

  def setting(name, label)
    @name = name
    @label = label
    render
  end

end