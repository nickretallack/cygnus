class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include ApplicationHelper
  include Generic #we have a genericized controller platform, it's kinda cool, look up generic for more information

  def activate_session(user)
      session[:username] = user.name
      session[:toasts_seen] = current_user.unread_messages.length
  end

  def deactivate_session
    session.delete(:username)
    @current_user = nil
  end
end
