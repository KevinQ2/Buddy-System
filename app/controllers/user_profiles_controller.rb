class UserProfilesController < ApplicationController
   before_action :redirect_if_not_user

  def show
    @user = current_user
  end

  def edit
    @user = User.find(current_user.id)
  end

  def update
    @user = User.find(current_user.id)
    @user.attributes = edit_user_info_params
    flash.alert = "Information successfully changed!"

    if @user.save(context: :self_update)
      redirect_to(user_profile_path)

    else
      render('edit')
    end
  end

  def edit_password
    @user = current_user
  end

  def update_password
    @user = current_user
    @user.attributes = edit_user_password_params

    if @user.save(context: :change_password)
      redirect_to(user_profile_path)
    else
      render('edit_password')
    end
  end

  private
    def edit_user_info_params
      params.require(:user).permit(:first_name, :last_name, :username)
    end

    def edit_user_password_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end
