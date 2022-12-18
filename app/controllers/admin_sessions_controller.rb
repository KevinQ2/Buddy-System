class AdminSessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: [:new, :create]
  def new
  end

  def create
    admin = Admin.find_by(username: params[:session][:username].downcase)
    if admin && admin.authenticate(params[:session][:password])
      admin_log_in(admin)
      redirect_to(admin_profile_path)
    else
      flash.now[:danger] = "invalid email or password"
      render "new"
    end
  end

  def destroy
    admin_logout
    redirect_to(admin_login_path)
  end

end
