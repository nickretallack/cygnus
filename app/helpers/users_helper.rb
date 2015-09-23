module UsersHelper

	# current user

	def first_log_in(user)
    Pool.new(title: "Gallery", user_id: user.id).save!
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

  def at_least(grade)
    User.level_for(current_user.level) >= User.level_for(grade)
  end

  def can_modify?(user)
    @can_modify ||= at_least(:mod) or current_user? user
  end

  def can_watch?(user)
    @can_watch ||= at_least(:admin) or (not anon? and not current_user? user)
  end

  def watching?(user)
    current_user.watching.include? user.id
  end

  def can_fav?(submission)
    @can_fav ||= (not anon? and not current_user? submission.pool.user)
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
        back
      end
    when :permission
      user ||= User.new(name: params[User.slug] || "any other user")
      unless can_modify? user
        flash[:danger] = "you are #{current_user.name} and are not allowed to view or modify #{user.name}'s records."
        back
      end
    when :existence
      unless user
        flash[:danger] = "no such user"
        back
      end
    else
      unless Proc.new.call
        flash[:danger] = "you do not have permission to do that"
        back
      end
    end
  end

  ###commission status###

  #statuses
  #
  #displays or allows modification of commission status for given user
  #gotchas:
  #
  # verbose status on the current user assumes that we want to modify statuses and are inside a form for "user"
  # in condensed status, icons are not in a table and will not display properly without fixed-width icons
  #
  #params:
  #
  # user means the user whose statuses we are displaying
  # verbosity means the level of verbosity to display:
  #   :verbose or (no argument) means icons and descriptive names are displayed side by side
  #     if the statuses are those of the logged-in user, select menus will be displayed
  #     allowing the user to modify his or her commission statuses
  #   :condensed means icons only with tooltip descriptions are displayed
  #
  #examples:
  #
  # <% enum_for @users do |user| %>
  #   <%= statuses user, :condensed %>
  # <% end %>
  #
  #
	def statuses(user, verbosity = :verbose)
		html = ""
		case verbosity
		when :verbose
			for i in 0..user.statuses.length-1
				html << "<div class = 'row'>"
				html << "<div class = 'col s6'>"
				html << "<i class = 'small material-icons'>#{CONFIG[:commission_icons].values[i]}</i> #{CONFIG[:commission_icons].keys[i].capitalize}:"
				html << "</div>"
				status = user.statuses[i]
				html << "<div class = 'col s6'>"
				if can_modify? user
					html << "<select name = 'user[statuses][#{i}]' class = 'btn button-with-icon'>"
					CONFIG[:activity_icons].each_with_index do |(key, value), index|
						html << "<option class = 'comm-#{CONFIG[:activity_icons].keys[index]}' value = #{index} #{"selected = 'selected'" if status == index}>#{key.to_s.gsub("_", " ")}</option>"
					end
					html << "</select>"
				else
					html << "<i class = 'small material-icons comm-#{CONFIG[:activity_icons].keys[status]}'>#{CONFIG[:activity_icons].values[status]}</i> #{CONFIG[:activity_icons].keys[status].capitalize}"
				end
				html << "</div>"
				html << "</div>"
			end
		when :condensed
			CONFIG[:commission_icons].each do |key, icon|
				html << "<i class = 'small material-icons' title = '#{key.capitalize}'>"+icon+"</i>"
			end
			html << "<br />"
			user.statuses.each do |status|
				html << "<i class = 'small material-icons comm-#{CONFIG[:activity_icons].keys[status]}' title = '#{CONFIG[:activity_icons].keys[status].to_s.gsub("_", " ").titleize}'>#{CONFIG[:activity_icons].values[status]}</i>"
			end
		end
		html.html_safe
	end
end
