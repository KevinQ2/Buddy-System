class ApplicationController < ActionController::Base
  include ApplicationHelper
  include UserSessionsHelper
  include AdminSessionsHelper

  before_action :session_expiry
  before_action :update_activity_time

  def session_expiry
    if logged_in? || admin_logged_in?
      unless session[:expires_at] > Time.now
        flash.now[:error] = "Your session has timed out. Please log back in."

        if logged_in?
          log_out
        elsif admin_logged_in?
          admin_logout
        end
      end
    end
  end

  def update_activity_time
    session[:expires_at] = 15.minutes.from_now
  end


  def redirect_if_not_logged_in
    unless logged_in?
      redirect_to user_login_url
    end
  end

  def redirect_if_not_admin
    unless admin_logged_in?
      redirect_to admin_login_url
    end
  end

  def redirect_if_not_admin_or_customer
    unless logged_in? || admin_logged_in?
      redirect_to user_login_url
    end
  end

  def redirect_if_not_user
    unless logged_in?
      redirect_to user_login_path
    end
  end

  def redirect_if_logged_in
    if logged_in?
      redirect_to users_path
    elsif admin_logged_in?
      redirect_to admins_path
    end
  end

  def redirect_if_not_permission
    unless logged_in? || admin_logged_in?
      flash.alert = "Please log in"
      redirect_to login_path
      return false
    end

    if has_permission(controller_name)
      return true
    else
      flash.alert = "Permission denied: " + controller_name

      if logged_in?
        redirect_to users_path
      else
        redirect_to admin_profile_path
      end
    end
  end

end
