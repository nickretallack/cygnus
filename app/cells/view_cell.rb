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

  def page_nav
    @page = (params[:page] || "1").to_i
    @total = controller.instance_variable_get("@total_#{controller.controller_name}")
    @results_per_page = controller.controller_name.classify.constantize.results_per_page
    render unless @total <= @results_per_page
  end

end