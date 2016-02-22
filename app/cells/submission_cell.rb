class SubmissionCell < HelpfulCell

  def new
    @pool = controller.instance_variable_get("@pool")
    render
  end

  def edit
    @submission = @model
    @pool = @submission.pool
    @user = @pool.user
    @title = title_for submission: @submission
    render
  end

  def item
    @pool = controller.instance_variable_get("@pool")
    render
  end

  def header(options)
    case options[:action]
    when :show
      title_for @submission
    end
  end

end