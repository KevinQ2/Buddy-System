class UserSessionsController < ApplicationController
before_action :redirect_if_logged_in, only: [:new, :create]
  
  def new
    
  end

  def create
    user = User.find_by(username: params[:session][:username].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      # Check if before login user requested certain URL
      if session[:return_to] != nil
        redirect_to_url_path = session[:return_to]
        # Clear saved URL
        session[:return_to] = nil
        # Redirect user to the requested URL
        redirect_to redirect_to_url_path
      else
        redirect_to(users_path)
      end
    else
      flash.now[:danger] = "invalid input"
      render "new"
    end
  end

  def destroy
    log_out
    redirect_to(root_url)
  end
 
end
