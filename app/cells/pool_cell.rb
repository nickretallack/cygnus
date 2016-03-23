class PoolCell < HelpfulCell

  ["new", "summary", "index", "pools", "show", "enum", "head"].each do |method|
    define_method method do
      render method
    end
  end

  def instructions(options)
    case options[:action]
    when :index
      @title = "Create a New Pool"
      @content = "Click the add button in the lower right of your screen to make a new pool. The pool is now created in the database and appears at the end of the list. Enter the pool by clicking on its name in order to change its name and upload submissions to it. To destroy the pool, click the trash icon. To make it your main gallery, click the list-top icon."
    end
    render if can_modify? @user and @title
  end

end