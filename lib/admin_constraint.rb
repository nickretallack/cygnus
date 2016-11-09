class AdminConstraint
  def matches?(request)
            puts request.session.to_json

    return false unless request.session[:username]
    user = User.find_slug request.session[:username]
    user && user.at_least?(:admin) 

  end
end