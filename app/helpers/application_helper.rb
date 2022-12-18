module ApplicationHelper
    include AdminSessionsHelper
    include UserSessionsHelper

    # Used to show the title in the browser
    def full_title(page_title = '')
        default_title = "Buddy"
        if page_title.empty?
            default_title
        else
            "#{default_title} | #{page_title}"
        end
    end

    # Store requested URL in session, mostly used for login purposes
    def store_return_to
        session[:return_to] = request.url
    end

    # If URL for non existent scheme is requested, redirect to home page
    def redirect_if_scheme_nonexisting
        if params[:scheme_id]!=nil && !Scheme.exists?(params[:scheme_id])
            flash[:alert] = "Sorry, url with requested scheme does not exist"
            redirect_to root_path
        end
    end


    # If user is already enrolled in the schema or schema has ended, redirect to homepage and notify
    def redirect_if_user_enrolled_or_schema_ended
        if EnrollIn.find_by(user_id: current_user.id)
            flash[:alert] = "Sorry, you have already enrolled into this schema"
            redirect_to root_path
        elsif Scheme.find(params[:scheme_id]).endDate < Date.current
          flash[:alert] = "Sorry, scheme has ended"
          redirect_to root_path
        end
    end

    def has_permission(accessName)
      master_permissions = {

        "admins" => "",
        "admin_mailings" => "coordinator",
        "mailing_list" => "",
        "coordinators" => "",
        "departments" => "",
        "reports" => "all",
        "matches" => "coordinator"
      }

      permission = master_permissions[accessName]

      # check if controller is not accounted for
      if permission == nil
        if ["schemes"].include?accessName
          if admin_logged_in?
            case current_admin.scheme_access
            when "assigned schemes"
              return current_admin.scheme_ids.count > 0
            when "assigned departments"
              return current_admin.department_ids.count > 0
            when "assigned departments and schemes"
              return (current_admin.scheme_ids.count > 0 || current_admin.department_ids.count > 0)
            when "all schemes"
              return true
            end
          else
            return false
          end
        else
          flash.alert = "Not found: " + accessName
          return false
        end
      end

      unless logged_in? || admin_logged_in?
        return false
      end

      if admin_logged_in?
        unless current_admin.admin_access.nil?
          return current_admin.admin_access.include?accessName
        end
        return false
      else
        case permission
        when ""
          return false
        when "all"
          return true
        else
          return EnrollIn.exists?(:user_id => current_user.id, :role => permission)
        end
      end
    end
end
