class ReportsController < ApplicationController

  include UserSessionsHelper
  include AdminSessionsHelper

  def new

    @report = Report.new

    if !logged_in?
      redirect_to('/user/login')
    elsif admin_logged_in?
      redirect_to(reports_path)
    end

    if !current_user.nil?

      @current_user_scheme = EnrollIn.select(:scheme_id).where(user_id: current_user)
      @list = EnrollIn.select(:user_id).where(scheme_id: @current_user_scheme)
      @current_user_username = current_user.username

    end

  end


  def create
    @current_user_scheme = EnrollIn.select(:scheme_id).where(user_id: current_user)
    @list = EnrollIn.select(:user_id).where(scheme_id: @current_user_scheme)
    @current_user_username = current_user.username
    @report = Report.create(
      reporter_id: User.where(username: params[:report][:reporter]).ids.first,
      reportee_id: User.where(username: params[:report][:reportee]).ids.first,
      message: params[:report][:message])
    if !@report.valid?
      @report.errors.full_messages.each do |msg|
        flash[:danger] = msg
      end
      render(new_report_path)
    end

  end


  def index

    if !logged_in? && !admin_logged_in?
      redirect_to("/user/login")
    elsif !admin_logged_in?
      redirect_to(new_report_path)
    else
      @current_user_schemes = current_admin.scheme_ids
    end


    @list = EnrollIn.where(["scheme_id = ?", @current_user_schemes]).pluck(:user_id)
    @reports = Report.where(handled: false).where(["reporter_id = ?", @list])


  end

  def update

    report = Report.find(params[:id])
    report.handled = !report.handled
    report.save
    if report.handled == true
      redirect_to(reports_path)
    else
      redirect_to(reports_handled_path)
    end

  end

  def destroy
  
    report = Report.find(params[:id])
    report.destroy
    flash[:info] = "The report has been successfully deleted!"
    redirect_to(reports_handled_path)
  
  end

  def handled

    if !logged_in? && !admin_logged_in?
      redirect_to('/user/login')
    elsif !admin_logged_in?
      redirect_to(new_report_path)
    else
      @current_user_schemes = current_admin.scheme_ids
    end


    @list = EnrollIn.where(["scheme_id = ?", @current_user_schemes]).pluck(:user_id)
    @reports = Report.where(handled: true).where(["reporter_id = ?", @list])

  end

  def show


    @report_table = params[:table]
    @report_to_show = Report.find(params[:id])
    @backlink
    @button
    if @report_to_show.handled == false
      @backlink = "/reports"
      @button = "Handle"
    elsif @report_to_show.handled == true
      @backlink = "/reports/handled"
      @button = "Unhandle"
    else
      @button = "3232"
    end

  end



  private

    def report_params
      params.require(:report).permit(:reporter, :reportee, :message)
    end

end
