module UsersHelper

  # current user

  def first_log_in(user)
    pool = Pool.new(title: "Gallery")
    pool.save!
    new_lookup(user: user.id, pool: pool.id)
    activate_session user
    flash[:success] = "welcome to "+CONFIG[:name]
    session.delete(:email)
  end

  def current_user
    @current_user ||= session[:username].nil?? AnonymousUser.new : User.find(session[:username]) || AnonymousUser.new
  end

  def anon?
    current_user.instance_of? AnonymousUser
  end

  def current_user?(user)
    user == current_user
  end

  # permission

  def get_user
    @user = User.find(params[User.slug]) if params[User.slug]
  end

  def at_least(grade)
    User.level_for(current_user.level) >= User.level_for(grade)
  end

  def can_modify?(user)
    at_least(:mod) or current_user? user
  end

  def can_watch?(user)
    at_least(:admin) or (not anon? and not current_user? user)
  end

  def watching?(user)
    current_user.watching.include? user.id
  end

  def can_fav?(submission)
    not anon? and not current_user? submission.pool.user
  end

  def faved?(submission)
    current_user.favs.include? submission.id
  end

  #insist_on
  #
  #shunts an unqualified user to a safe path with the appropriate message
  #could be modified to send emails to administrators for repeat offenses
  #gotchas:
  #
  # must be used inside a separate method like a before_filter to avoid calling redirect twice in the same action
  #
  #examples:
  #
  # before_filter -> { insist_on :logged_in }, only: [:create]
  #
  # before_filter -> {
  #   @user = User.find(params[User.slug])
  #   insist_on :permission @user
  # }, only: [:update, :destroy]
  #
  # before_filter -> {
  #   @user = User.find(params[User.slug])
  #   insist_on :existence @user
  # }, only: [:show]
  #
  # before_filter -> {
  #   @user = User.find(params[User.slug])
  #   @comment = Messages.find(params[Message.slug])
  #   insist_on do                         #
  #     @user.comments.include? @comment   # shunt unless true block
  #   end                                  #
  # }, only: [:edit]
  #
  def insist_on(type = nil, user = nil)
    case type
    when :logged_in
      if anon?
        flash[:danger] = "please sign in first"
        redirect_to :root
      end
    when :permission
      user ||= User.new(name: params[User.slug] || "any other user")
      unless can_modify? user
        flash[:danger] = "you are #{anon?? "not signed in" : "signed in as #{current_user.name}"} and are not allowed to view or modify #{user.name}'s personal records"
        redirect_to :root
      end
    when :existence
      unless user
        flash[:danger] = "no such user"
        redirect_to :root
      end
    else
      unless Proc.new.call
        flash[:danger] = "you do not have permission to do that"
        redirect_to :root
      end
    end
  end

end