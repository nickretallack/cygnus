class ViewCell < HelpfulCell

  def hidable(options)
    @title = options[:title] || ""
    @content = options[:content] || ""
    @open = options[:open] || false
    @associated = options[:associated]
    @on_destroy = options[:on_destroy]
    render
  end

  def setting(name, label)
    @name = name
    @label = label
    render
  end

  def page_nav
    @path = Proc.new{ |page|
      parent = params.keys.collect{|key| /(.+)_id/.match(key)}.compact[0][1] rescue nil
      if parent
        self.send("#{controller.controller_name}_path", controller.instance_variable_get("@#{parent}"), page)
      else
        self.send("#{controller.controller_name}_path", page)
      end
    }
    @page = (params[:page] || "1").to_i
    @total = controller.instance_variable_get("@total_#{controller.controller_name}")
    @results_per_page = controller.controller_name.classify.constantize.results_per_page
    render unless @total <= @results_per_page
  end

  def markdown_cheatsheet
    cell(:view).(:hidable, title: "Markdown Cheatsheet", content: render)
  end

  ["footer"].each do |method|
    define_method method do
      render method
    end
  end

end