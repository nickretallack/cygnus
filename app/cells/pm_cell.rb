class PmCell < HelpfulCell

  ["index", "show", "edit"].each do |model|
    define_method model do
      render model
    end
  end

  def new
    if @model.instance_of? User
      @path = new_pm_path(@user, @model)
    elsif @model.instance_of? Message
      if @model.pm_author == @user
        @path = new_pm_path(@user, @model.recipient, @model)
      else
        @path = new_pm_path(@user, @model.pm_author, @model)
      end
    end
    @word = @user.setting(:view_adult)? "hot" : "quick"
    render
  end

end