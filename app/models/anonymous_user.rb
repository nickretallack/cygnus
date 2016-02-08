class AnonymousUser
  def id
    0
  end

  def pools
    ActiveRecord::Relation.new
  end

  def level
    :unactivated
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

  def view_adult?
    false
  end
end
