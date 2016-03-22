class SubmissionCell < HelpfulCell

  ["new", "show", "edit", "index", "favorite"].each do |method|
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
      if @pool
        if can_modify? @pool.user
          unless options[:sanitize]
            ""
          else
            "#{title_for @pool} (#{@pool.user.name})"
          end
        else
          unless options[:sanitize]
            "#{title_for @pool} (#{link_to @pool.user.name, user_path(@pool.user.name)})"
          else
            "#{title_for @pool} (#{@pool.user.name})"
          end
        end
      else
        "All submissions"
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
      @title = "Create a New Submission"
      @content = "Click the add button below to make a new submission. The submission is now created in the database and appears at the beginning of the pool but is not visible to other users until you unhide it. Click on the submission to edit its title and description and to upload an image. You can unhide it while saving your changes or come back to this page to do so. To delete the submission, its image, and all of its comments, click the trash icon."
    end
    render if can_modify? @user and @title
  end

end