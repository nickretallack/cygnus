module CellHelper

  def cell_defined?
    @klass ||= "#{controller_name.classify}Cell".constantize rescue false
  end

  def cell_instructions?
    return false unless cell_defined?
    @klass.instance_methods.include? :instructions
  end

  def cell_footer?
    return false unless cell_defined?
    @klass.instance_methods.include? :footer
  end

end