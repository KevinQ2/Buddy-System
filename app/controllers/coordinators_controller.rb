class CoordinatorsController < ApplicationController
  before_action :redirect_if_not_permission


  def index
    @coordinators = EnrollIn.where(role:"coordinator")
  end

  def index_all
    @coordinators = EnrollIn.where(role:"coordinator")
  end

  def show_coordinator
    @coordinator = EnrollIn.find(params[:id])
  end

  def new_coordinator
    @coordinator = EnrollIn.new
  end

  def new
    @coordinator = EnrollIn.new
    @schemes = Scheme.all
  end


  def create_coordinator
    @coordinator = EnrollIn.new(coordinator_params)
    @coordinator.scheme_id = params[:scheme_id]
    @coordinator.role = "coordinator"

    @user = User.find_by(username: params[:enroll_in][:user_id].downcase)
    if @user.exists?
      @coordinator.user_id = @user.id
    end

    if @coordinator.save
      flash[:alert]="Coordinator created"
      redirect_to coordinators_path(params[:scheme_id])
    else
      flash[:alert]="Coordinator NOT created"
      redirect_to request.referrer
    end
  end

  def create
    @coordinator = EnrollIn.new(coordinator_params)
    @coordinator.scheme_id = params[:schemes]
    @coordinator.role = "coordinator"

    @user = User.find_by(username: params[:enroll_in][:user_id].downcase)
    unless @user.nil?
      @coordinator.user_id = @user.id
    end

    if @coordinator.save
      flash[:alert]="Coordinator created"
      redirect_to coordinators_path(params[:scheme_id])
    else
      flash[:alert]="coordinator NOT created"
      redirect_to request.referrer
    end
  end

  def edit
    @coordinator = EnrollIn.find(params[:id])
  end

  def update
    @coordinator = EnrollIn.find(params[:id])
      if @coordinator.update(coordinator_update_params)
          @coordinator.save
          flash[:info] = "Enrollment Updated."
          redirect_to coordinator_path
      else
          render 'edit'
      end
  end

  def delete
    @coordinator = EnrollIn.find(params[:id])
    redirect_to delete_coordinators_path(params[:scheme_id])
  end

  def destroy
    @coordinator = EnrollIn.find(params[:id])

    @coordinator.destroy
    flash[:info] = "The coordinator has been successfully deleted!"
    redirect_to request.referrer
  end

  private
    def coordinator_params
      params.require(:enroll_in).permit( :user_id)
    end

    def coordinator_update_params
      params.require(:enroll_in).permit(:role, :user_id)
    end
end
