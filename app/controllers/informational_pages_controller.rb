class InformationalPagesController < ApplicationController

    # For all public pages to show
    def show
        if valid_page?
            # Support contact is only needed in problem solving page
            if params[:page]== "problem_solving"
                @support_contact = ENV["support_contact"]
            end
            render template: "/informational_pages/#{params[:page]}"
        else
            flash[:error] = "page does not exist"
            redirect_to root_path
        end
    end

    def welcome_page

    end



    private
    # Check if the page user is trying to access exists
    def valid_page?
        File.exist?(Pathname.new(Rails.root + "app/views/informational_pages/#{params[:page]}.html.erb"))
    end


end
