class CommentCell < HelpfulCell

  ["index", "edit"].each do |method|
    define_method method do
      render method
    end
  end

  def new(indent = 0)
    @submission = controller.instance_variable_get("@submission") || Submission.find(params[Submission.slug])
    @word = @submission.image.explicit?? "hot" : "quick"
    @indent = indent
    render
  end

  def show(indent)
    @indent = indent
    render
  end

end