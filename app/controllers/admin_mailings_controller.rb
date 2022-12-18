class AdminMailingsController < ApplicationController
    before_action :redirect_if_not_permission

    
    # General page from which can be redirected to more specific mailing
    def communications
        
    end

    # Page for mailing the people in uploaded mailing list from .csv file (by super-admin)
    def mail_list
        @numberOfEmails = MailingList.count
    end

    # Page for mailing the various registered users that can be selected by various filters
    def mail_users
        if admin_logged_in?
            if current_admin.scheme_access = "all schemes"
                @scheme_options = Scheme.all
            end
            if current_admin.scheme_access = "assigned schemes"
                @scheme_options = Scheme.where(id: current_admin.scheme_ids)
            end
            if current_admin.scheme_access = "assigned departments"
                @scheme_options = Scheme.where(department_id: current_admin.department_ids)
            end
            if current_admin.scheme_access = "assigned departments and schemes"
                @scheme_options = Scheme.where(department_id: current_admin.department_ids) + Scheme.where(id: current_admin.scheme_ids) 
                @scheme_options = @scheme_options.uniq
            end
        elsif logged_in? && EnrollIn.exists?(user_id: current_user.id, role: "coordinator")
            @enroll = EnrollIn.where(user_id: current_user.id, role: "coordinator")
        end
        @role_options = ["all", "coordinator", "mentee", "mentor"]
    end

    # Sends email when ready from mailing list
    def send_email_mailinglist
        @mailingList = MailingList.all
        subject = params[:subject]
        content = params[:content]
        @mailingList.each do |recipient|
            CommunicationMailer.email_mailinglist(recipient,subject,content).deliver_later
        end
        # Inform that emails were sent
        flash[:alert] = "Emails were sent to the recipients in the mailing list"
        redirect_to mail_list_path
    end

    # Sends email when ready from registered users list
    def send_email_mailingusers
        if params[:role] == "all"
            @recipients = EnrollIn.where(scheme_id: params[:scheme_id])
            @emails = User.where(id: @recipients).pluck(:username)   
        else
            @recipients = EnrollIn.where(scheme_id: params[:scheme_id], role: params[:role])
            @emails = User.where(id: @recipients).pluck(:username)  
        end
        subject = params[:subject]
        content = params[:content]
        @emails.each do |email|
            CommunicationMailer.email_mailingusers(email,subject,content).deliver
        end
        # Inform that emails were sent
        flash[:alert] = "Emails were sent to the users enrolled in scheme - " + Scheme.find_by(id:params[:scheme_id]).title
        redirect_to mail_users_path
    end
    
end
