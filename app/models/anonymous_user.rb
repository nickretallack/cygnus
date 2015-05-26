class AnonymousUser
  def id
    nil
  end

  def level
    0
  end
  
  def created_at
    Time.now
  end
  
  def updated_at
    Time.now
  end
  
  def name
    "Anonymous"
  end

  def pretty_name
    "Anonymous"
  end

  def is_anonymous?
    true
  end
  
  CONFIG["user_levels"].each do |name, value|
    normalized_name = name.downcase.gsub(/ /, "_")

    define_method("is_#{normalized_name}?") do
      false
    end

    define_method("is_#{normalized_name}_or_higher?") do
      false
    end

    define_method("is_#{normalized_name}_or_lower?") do
      true
    end
  end
end