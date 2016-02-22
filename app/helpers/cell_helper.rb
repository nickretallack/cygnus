module CellHelper

  def cell_defined?
    @klass ||= "#{controller_name.classify}Cell".constantize rescue false
  end

  def cell_header?
    return false unless cell_defined?
    @klass.instance_methods.include? :header
  end

  def cell_instructions?
    return false unless cell_defined?
    @klass.instance_methods.include? :instructions
  end

end