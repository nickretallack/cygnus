class PmCell < HelpfulCell

  ["index", "show", "summary"].each do |method|
    define_method method do
      render method
    end
  end

  ["new", "reply"].each do |method|
    define_method method do
      @user ||= current_user
      @word = @user.setting(:view_adult)? "hot" : "quick"
      render method
    end
  end

end