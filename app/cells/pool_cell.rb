class PoolCell < HelpfulCell

  def index
    @pools = @parent_controller.instance_variable_get("@pools")
    render
  end

end