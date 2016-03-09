class SubmissionCell < HelpfulCell

  ["new", "show", "edit", "index"].each do |method|
    define_method method do
      render method
    end
  end

  ["show_summary", "edit_summary"].each do |method|
    define_method method do
      render "#{method.split("_")[1]}/#{method.split("_")[0]}"
    end
  end

  def header(options)
    case options[:action]
    when :index
      if @user
        unless options[:sanitize]
          "#{link_to @user.name, user_path(@user.name)}'s #{title_for @pool}"
        else
          "#{@user.name}'s #{title_for @pool}"
        end
      else
        if @pool
          unless options[:sanitize]
            "#{title_for @pool} (#{link_to @pool.user.name, user_path(@pool.user.name)})"
          else
            "#{title_for @pool} (#{@pool.user.name})"
          end
        else
          "All submissions"
        end
      end
    when :show
      if (@pool and can_modify? @pool.user) or can_modify? @submission.pool.user
        nil
      else
        title_for @submission
      end
    end
  end

  def instructions(options)
    case options[:action]
    when :index
      @title = "Create a New Pool"
      @content = "Click the add button floating in the lower right of your screen to make a new pool. The pool is now created in the database and appears at the beginning of the list. To change its name, click the edit icon next to it, type the new name, and use the save icon to commit the change. To destroy the pool, click the trash icon."
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