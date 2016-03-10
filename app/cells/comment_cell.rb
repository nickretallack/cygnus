class CommentCell < HelpfulCell

  ["index", "edit"].each do |method|
    define_method method do
      render method
    end
  end

  def new
    @word = @submission.image.explicit?? "hot" : "quick"
    render
  end

  def show(indent)
    @indent = indent
    render
  end

end