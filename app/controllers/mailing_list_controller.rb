class MailingListController < ApplicationController

  before_action :redirect_if_not_permission


  # To show all emails that are imported
  # Access should be given to only Super-Admin
  def index
    @mailingList = MailingList.all
    @email = MailingList.new
  end

  def create
    @email = MailingList.new
    @email.email = params[:mailing_list][:email]
    if @email.save
      flash[:alert] = "Email was added to the list successfully"
      redirect_to mailing_list_index_path
    else
      flash[:alert] = "FAILURE! Email was NOT added to the list"
      redirect_to mailing_list_index_path
    end
  end

  # Used for .csv file import
  # Access should be given to only Super-Admin
  def import
    # Check if file is selected and file is in .csv format
    if params[:file] && File.extname(params[:file]) == ".csv"
      MailingList.import(params[:file])
      flash[:alert] = "Emails are successfully imported"
      redirect_to mailing_list_index_path
    else
      flash[:error] = "Only .csv files are allowed"
      redirect_to mailing_list_index_path
    end
  end

  def destroy
    @mailing_list = MailingList.find(params[:id])
    @mailing_list.destroy
    flash[:alert] = "Single email was deleted"
    # Wait that the system could delete the file and then the page be rendered
    sleep(1)
    redirect_to mailing_list_index_path
  end

  def destroy_all
    @all_emails = MailingList.all
    @all_emails.destroy_all
    flash[:alert] = "Mailing list was successfully erased"
    redirect_to mailing_list_index_path
  end

end