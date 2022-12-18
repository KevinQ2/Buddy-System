class AdminsController < ApplicationController
  before_action :redirect_if_not_permission
  before_action :check_admin_exist, except: [:index, :new, :create]

  def index
    @admins = Admin.order('username ASC')
  end

  def show
    @admin = Admin.find(params[:id])
  end

  def new
    @admin = Admin.new()
  end

  def create
    # Limit the params sent by the new_admins_params method
    @admin = Admin.new(new_admin_params)
    @admin.admin_access = params[:access]

    # Context allows specific data validation
    if @admin.save(context: :create)
      # Send registration email to registered admin
      AdminMailer.email_registered_admin(@admin).deliver_now
      flash[:alert] = "Admin is registered and notified by email"
      redirect_to(admins_path)
    else
      # In case there were errors in saving
      render('new')
    end
  end

  def edit
    @admin = Admin.find(params[:id])
  end

  def update
    @admin = Admin.find(params[:id])
    @admin.attributes = edit_admin_params
    @admin.admin_access = params[:access]

    if @admin.save
      redirect_to(admin_path(@admin))
    else
      render('edit')
    end
  end

  def delete
    @admin = Admin.find(params[:id])
  end

  def destroy
    @admin = Admin.find(params[:id])
    @admin.destroy
    AdminMailer.email_deleted_admin(@admin).deliver_now
    flash[:alert] = "Admin is deleted and notified by email"
    redirect_to(admins_path)
  end

  private
    # redirect to index page if record does not/no longer exists
    def check_admin_exist
      unless Admin.exists?(params[:id])
        redirect_to(admins_path)
      end
    end

    def new_admin_params
      params.require(:admin).permit(:username, :scheme_access, :department_ids => [], :scheme_ids => [])
    end

    def edit_admin_params
      params.require(:admin).permit(:scheme_access, :department_ids => [], :scheme_ids => [])
    end

end
