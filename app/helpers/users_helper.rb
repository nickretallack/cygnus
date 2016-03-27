module UsersHelper

  # current user

  def first_log_in(user)
    pool = Pool.new(title: "gallery")
    pool.save
    list_one = Card.new(title: "To Do")
    list_one.save
    list_two = Card.new(title: "Doing")
    list_two.save
    list_three = Card.new(title: "Done")
    list_three.save
    card = Card.new(attachments: ["card-#{list_one.id}", "card-#{list_two.id}", "card-#{list_three.id}"])
    card.save
    user.level = :member
    user.activated_at = Time.zone.now
    user.attachments = user.attachments << "pool-#{pool.id}" << "card-#{card.id}"
    user.save(validate: false)
    activate_session user
    flash[:success] = "welcome to #{CONFIG[:name]}"
    session.delete(:email)
  end

  def current_user
    session[:username].nil?? AnonymousUser.new : User.find(session[:username]) || AnonymousUser.new
  end

  def anon?
    current_user.instance_of? AnonymousUser
  end

  def current_user?(user)
    user == current_user
  end

  def setting(setting)
    current_user.setting(setting)
  end

  # search terms

  def search_defaults
    session[:terms] == CONFIG[:default_search_terms] rescue false
  end

  def search_all
    session[:terms]["use_statuses"].reject{ |key, value| value == "0" }.empty? and session[:terms]["statuses"].reject{ |key, value| value == "all open statuses" }.empty? rescue false
  end

  # permission

  def at_least?(grade)
    User.level_for(current_user.level) >= User.level_for(grade)
  end

  def can_modify?(user)
    user and (at_least?(:mod) or current_user? user)
  end

  def can_watch?(user)
    user and (at_least?(:admin) or (not anon? and not current_user? user))
  end

  def watching?(user)
    user and current_user.watching.include? user.id
  end

  def can_fav?(submission)
    submission and not anon? and not current_user? submission.user
  end

  def can_order?(user)
    user and user.order_forms.length > 0 and (CONFIG[:status_categories][:open].include? user.statuses[0].to_sym or user.setting(:non_open_orders))
  end

  def faved?(submission)
    submission and current_user.favs.include? submission.id
  end

  #insist_on must be used inside a separate method like a before_filter to avoid calling redirect twice in the same action

  def insist_on(type = nil, user = nil)
    case type
    when :logged_in
      if anon?
        flash[:danger] = "please sign in first"
        shunt_to_root
      end
    when :logged_out
      unless anon?
        flash[:danger] = "cannot perform this action while logged in"
        shunt_to_root
      end
    when :permission
      users = user.is_a?(ActiveRecord::Relation)? user : [user]
      users.each do |user|
        user ||= User.new(name: params[User.slug] || "any other user")
        unless can_modify? user
          flash[:danger] = "you are #{anon?? "not signed in" : "signed in as #{current_user.name}"} and are not allowed to view or modify #{user.name}'s personal records"
          shunt_to_root
        end
      end
    when :existence
      unless user
        flash[:danger] = "no such user"
        shunt_to_root
      end
    else
      unless Proc.new.call
        flash[:danger] = "you do not have permission to do that"
        shunt_to_root
      end
    end
  end

  #other

  def recent_submissions_from_watched
    submissions = []
    current_user.watching.each do |id|
      user = User.find_by(id: id)
      submissions = submissions | user.recent_submissions
    end
    submissions
  end

  def pm_partner(message)
    message.parents("user", "pm").select{ |user| user != current_user }.first
  end

end