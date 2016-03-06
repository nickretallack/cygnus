class AnonymousUser
  def id
    0
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
    "(anonymous)"
  end

  def email
    "(no email)"
  end

  def view_adult?
    false
  end

  def setting(key)
    false
  end
end
