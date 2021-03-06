class AnonymousUser
  def id
    0
  end
  
  def anon?
    true #permissions control
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

  def pools
    Pool.none
  end

  def announcements
    Message.none
  end
end