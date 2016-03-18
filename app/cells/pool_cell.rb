class PoolCell < HelpfulCell

  ["new", "summary", "index", "pools", "show"].each do |method|
    define_method method do
      render method
    end
  end

  def header(options)
    case options[:action]
    when :index
      if @user
        unless options[:sanitize]
          "Pools: #{link_to @user.name, user_path(@user.name)}"
        else
          "#{@user.name}'s pools"
        end
      else
        "All Pools"
      end
    end
  end

  def instructions(options)
    case options[:action]
    when :index
      @title = "Create a New Pool"
      @content = "Click the add button in the lower right of your screen to make a new pool. The pool is now created in the database and appears at the end of the list. Enter the pool by clicking on its name in order to change its name and upload submissions to it. To destroy the pool, click the trash icon. To make it your main gallery, click the list-top icon."
    when :show
      @title = "Create a New Submission"
      @content = "Click the add button floating in the lower left of your screen to make a new submission. The submission is now created in the database and appears at the beginning of the pool but is not visible to other users until you unhide it. Click on the submission to edit its title and description and upload an image. You will see an option on the same page to unhide the sumbmission."
    end
    if @user
      render if can_modify? @user
    elsif @user
      render if can_modify? @pool.user
    end
  end

end