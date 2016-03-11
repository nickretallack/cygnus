class PmCell < HelpfulCell

  def new
    if @model.instance_of? User
      @path = new_pm_path(current_user, @model)
    elsif @model.instance_of? Message
      @path = new_pm_path(current_user, @model.pm_author, @model)
    end
    render
  end

  def index
    render
  end

end