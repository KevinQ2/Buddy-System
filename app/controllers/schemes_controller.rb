class SchemesController < ApplicationController
    before_action :redirect_if_not_permission
    before_action :check_scheme_exist, except: [:index, :new, :create]
    before_action :redirect_if_not_assigned, except: [:index, :new, :create]

    def index
      if current_admin.scheme_access == "all schemes"
        @schemes = Scheme.all
      else
        @schemes = []

        Scheme.all.each do |scheme|
          if ["assigned schemes", "assigned departments and schemes"].include?(current_admin.scheme_access)
            if current_admin.scheme_ids.include?(scheme.id)
              @schemes.push(scheme)
              next
            end
          end
          if ["assigned departments", "assigned departments and schemes"].include?(current_admin.scheme_access)
            if current_admin.department_ids.include?(scheme.department_id)
              @schemes.push(scheme)
              next
            end
          end
        end
      end
    end

    def show
        @scheme = Scheme.find(params[:id])
        @questionnaire = Questionnaire.where(scheme_id: @scheme.id).first
        if @questionnaire != nil
           @questions = Question.where( questionnaire_id: @questionnaire.id)
        end
        @question =Question.new
        @coordinators = EnrollIn.where(scheme_id: @scheme.id)
    end

    def showcodeofconduct
        @codeOfConduct = Scheme.find(params[:id]).codeOfConduct
    end

    def new
        @scheme = Scheme.new
    end

    def create
        @scheme = Scheme.new
        @scheme.department_id = params[:scheme][:department_id]
        @scheme.title = params[:scheme][:title]

        @scheme.description = params[:scheme][:description]
        if params[:scheme][:startDate]
            startDate = params[:scheme][:startDate]
        else startDate = Date.new(params[:scheme]["startDate(1i)"].to_i,params[:scheme]["startDate(2i)"].to_i,params[:scheme]["startDate(3i)"].to_i)
        end
        @scheme.startDate = startDate
        if params[:scheme][:endDate]
            endDate = params[:scheme][:endDate]
        else endDate = Date.new(params[:scheme]["endDate(1i)"].to_i,params[:scheme]["endDate(2i)"].to_i,params[:scheme]["endDate(3i)"].to_i)
        end
        @scheme.endDate = endDate
        @scheme.codeOfConduct = params[:scheme][:codeOfConduct]

        if @scheme.save
            # Generate unique non-guessable link for enroll in
            @enroll_link = EnrollLink.new
            @enroll_link.scheme_id = @scheme.id
            @enroll_link.mentee_link = root_url.chomp("/")+enroll_mentee_path(@scheme.id, SecureRandom.hex(25))
            @enroll_link.mentor_link = root_url.chomp("/")+enroll_mentor_path(@scheme.id, SecureRandom.hex(25))
            @enroll_link.save
          @questionnaire = Questionnaire.new
          render 'questionnaires/new'
        else
            flash[:alert] = @scheme.errors.full_messages.to_sentence
            render 'new'
        end
    end

    def edit
        @scheme = Scheme.find(params[:id])
        if !helpers.isValidEditDate(@scheme.startDate)
            flash[:alert] = "The scheme has already started, it is not editable"
            redirect_to schemes_path
        end
    end

    def update
        @scheme = Scheme.find(params[:id])
        @scheme.department_id = params[:scheme][:department_id]
        @scheme.title = params[:scheme][:title]
        @scheme.description = params[:scheme][:description]
        @scheme.codeOfConduct = params[:scheme][:codeOfConduct]
        if params[:scheme][:startDate]
            startDate = params[:scheme][:startDate]
        else startDate = Date.new(params[:scheme]["startDate(1i)"].to_i,params[:scheme]["startDate(2i)"].to_i,params[:scheme]["startDate(3i)"].to_i)
        end
        @scheme.startDate = startDate
        if params[:scheme][:endDate]
            endDate = params[:scheme][:endDate]
        else endDate = Date.new(params[:scheme]["endDate(1i)"].to_i,params[:scheme]["endDate(2i)"].to_i,params[:scheme]["endDate(3i)"].to_i)
        end
        @scheme.endDate = endDate
        if @scheme.save
            redirect_to scheme_path(@scheme.id)
        else
            flash[:alert] = @scheme.errors.full_messages.to_sentence
            render 'edit'
        end
    end


    def delete
        @scheme = Scheme.find(params[:id])
        render('delete')
      end

    def destroy
        @scheme = Scheme.find(params[:id])
        @scheme.destroy
        flash[:alert] = "Scheme was sucessfully deleted"
        redirect_to schemes_path
      end


    private
      def check_scheme_exist
        unless Scheme.exists?(params[:id])
          redirect_to schemes_path
        end
      end

      def redirect_if_not_assigned
        if current_admin.scheme_access == "all schemes"
          return true
        end

        scheme = Scheme.find(params[:id])

        # redirect if current scheme page is not permitted to the admin
        if ["assigned schemes", "assigned departments and schemes"].include?(current_admin.scheme_access)
          if current_admin.scheme_ids.include?(scheme.id)
            return true
          end
        end
        if ["assigned departments", "assigned departments and schemes"].include?(current_admin.scheme_access)
          if current_admin.department_ids.include?(scheme.department_id)
            return true
          end
        end

        redirect_to schemes_path
      end

end
