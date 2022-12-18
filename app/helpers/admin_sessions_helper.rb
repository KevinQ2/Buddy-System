module AdminSessionsHelper
  def admin_log_in(admin_user)
    session[:admin_username] = admin_user.username
  end

  def current_admin
    if session[:admin_username]
      Admin.find_by(username: session[:admin_username])
    end
  end

  def admin_logged_in?
    !current_admin.nil?
  end

  def admin_logout
    session.delete(:admin_username)
    current_admin = nil
  end

  # Checks if current user is Super Admin temporary until login will be implemented
  def super_admin_logged_in?
    !current_admin.nil? && current_admin.admin_level ==1
  end

end
