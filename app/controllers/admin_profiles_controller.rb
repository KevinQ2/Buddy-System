class AdminProfilesController < ApplicationController
  # temporary
  before_action :redirect_if_not_admin

  def show
    @admin = current_admin
  end

  def edit
    @admin = Admin.find(current_admin.id)
  end

  def update
    @admin = Admin.find(current_admin.id)
    @admin.attributes = edit_admin_info_params

    if @admin.save(context: :self_update)
      redirect_to(admin_profile_path)
    else
      render('edit')
    end
  end

  def edit_password
    @admin = current_admin
  end

  def update_password
    @admin = current_admin
    @admin.attributes = edit_admin_password_params

    if @admin.save(context: :change_password)
      redirect_to(admin_profile_path)
    else
      render('edit_password')
    end
  end

  private
    def edit_admin_info_params
      params.require(:admin).permit(:first_name, :last_name)
    end

    def edit_admin_password_params
      params.require(:admin).permit(:password, :password_confirmation)
    end
end
