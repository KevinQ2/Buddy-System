class UsersController < ApplicationController

before_action :redirect_if_not_logged_in, only: [:index, :show]

  
def index
  unless logged_in?
    redirect_to login_path
  end
  @enrolled = EnrollIn.where(user_id: current_user.id)
end

def new
  @user = User.new({:username => email.downcase})
end

  def show
    @user = User.find(params[:id])
  end


def create
  @user = User.new(user_params)
    if @user.valid?
        @user.save
        if session[:return_to]
          redirect_to session[:return_to]
        else
          redirect_to(root_url)
        end
    else
        render('new')
    end
end


def user_params
    params.require(:user).permit(:username,:first_name, :last_name,
     :password, :password_confirmation)
end

def email
  @email = params[:email]
end


end
