class PoolCell < HelpfulCell

  def new
    render
  end

  def index
    if @user
      @pools = @user.pools
    else
      @pools = Pool.all
    end
    render
  end

  def header(options)
    case options[:action]
    when :index
      if @user
        unless options[:sanitize]
          "#{link_to @user.name, user_path(@user.name)}'s pools"
        else
          "#{@user.name}'s pools"
        end
      else
        "All Pools"
      end
    end
  end

  def instructions(action)
    case action
    when :index
      @title = "Create a New Pool"
      @content = "Click the add button floating in the lower left of your screen to make a new pool. Once created, the pool will appear at the end of the list. To change its name, click the edit icon next to it, type the new name, and use the save icon to commit the change. To destroy the pool, click the trash icon."
    end
    render if @user and can_modify? @user
  end

end