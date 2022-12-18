module UserSessionsHelper
  def log_in(user)
    session[:username] = user.username
  end

  def current_user
    if session[:username]
      User.find_by(username: session[:username])
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:username)
    @current_user = nil
  end

end
