class EnrollInMailingsController < ApplicationController

    # Check if requested URL scheme exists
    before_action :redirect_if_scheme_nonexisting


    # To show all emails that are imported
    def index
        @enroll_mailing_list = EnrollInMailing.all

    end

    # Send emails to imported list for selected role
    def send_emails
        @enroll_mailing_list = EnrollInMailing.all
        @recipientRole = params[:role]
        @url = request.base_url+enroll_mentee_path(params[:scheme_id])
        # If selected role is Mentor, send enroll in emails to mentors
        if @recipientRole == "Mentor"
            send_email_to_mentors(@enroll_mailing_list, @url)
            flash[:alert] = "Emails are successfully sent to " + @recipientRole + "s"
            
            redirect_to request.referrer
        # If selected role is Mentees, send enroll in emails to mentees
        elsif @recipientRole == "Mentee"
            send_email_to_mentees(@enroll_mailing_list, @url)
            flash[:alert] = "Emails are successfully sent to " + @recipientRole + "s"
            redirect_to request.referrer
        else 
            flash[:alert] = "Wrong role selected"
            redirect_to request.referrer
        end
        # After emails are sent, delete all records
        EnrollInMailing.destroy_all
    end


    # Used for .csv file import
    def import
        # Check if file is selected and file is in .csv format
        if params[:file] && File.extname(params[:file]) == ".csv"
            EnrollInMailing.import(params[:file])
            flash[:alert] = "Emails are successfully imported"
            redirect_to  request.referrer
        else
            flash[:error] = "Only .csv files are allowed"
            redirect_to  request.referrer
        end
    end


    # To show all emails that are imported
    def destroy_all
        @all_emails = EnrollInMailing.all
        @all_emails.destroy_all
        flash[:alert] = "All emails were successfully erased"
        redirect_to request.referrer
    end


        # Send enroll in emails to mentees
        private 
        def send_email_to_mentees(recipients, url)
            recipients.each do |recipient|
                EnrollInCommunicationMailer.email_mentee_enroll_in(recipient, url).deliver_later
            end
        end

        # Send enroll in emails to mentors
        private 
        def send_email_to_mentors(recipients, url)
            recipients.each do |recipient|
                EnrollInCommunicationMailer.email_mentor_enroll_in(recipient, url).deliver_later
            end
        end

end
