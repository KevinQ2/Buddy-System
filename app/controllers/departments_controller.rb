class DepartmentsController < ApplicationController
  before_action :redirect_if_not_permission
  before_action :check_department_exist, except: [:index, :new, :create]

  def index
    @departments = Department.all
  end

  def show
    @department = Department.find(params[:id])
  end

  def new
    @department = Department.new()
  end

  def create
    # Limit the params sent by the new_admins_params method
    @department = Department.new(form_params)

    # Context allows specific data validation
    if @department.save
      # Send registration email to registered admin
      redirect_to(departments_path)
    else
      # In case there were errors in saving
      render('new')
    end
  end

  def edit
    @department = Department.find(params[:id])
  end

  def update
    @department = Department.find(params[:id])

    @department.attributes = form_params

    if @department.save
      redirect_to(department_path(@department))
    else
      render('edit')
    end
  end

  def delete
    @department = Department.find(params[:id])
  end

  def destroy
    @department = Department.find(params[:id])
    @department.destroy
    redirect_to(departments_path)
  end

  private
    def form_params
      params.require(:department).permit(:name)
    end

    def check_department_exist
      unless Department.exists?(params[:id])
        redirect_to departments_path
      end
    end
end
