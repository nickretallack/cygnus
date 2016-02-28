String.class_eval do

  def to_bool
    if self == "true"
      true
    elsif self == "false"
      false
    else
      self
    end
  end

end