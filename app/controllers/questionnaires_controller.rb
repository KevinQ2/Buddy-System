class QuestionnairesController < ApplicationController

  @questionnaire_to_be_copied = nil

  before_action :redirect_if_not_admin_or_coordinator
  before_action :redirect_if_not_assigned, only: [:show, :edit, :update, :delete, :destroy]
  before_action :check_questionnaire_exist, except: [:index, :new, :create]

  def index
    @questionnaires = Questionnaire.all
  end

  def show
    @questionnaire = Questionnaire.find(params[:id])
    @questions = Question.where( questionnaire_id: params[:id])
    @question =Question.new
    render('show')
  end

  def new
    @questionnaire = Questionnaire.new
    render('new')
  end


  def create
    @questionnaire = Questionnaire.new(questionnaire_params)
    unless @questionnaire.save
        flash[:info] = "Questionnaire is not saved."
        render('new')
    else
      if $copied_questionnaire_questions != nil
         $copied_questionnaire_questions.each do |question|
           @question_copy = question.dup
           @question_copy.questionnaire_id = @questionnaire.id
           @question_copy.save
         end
      end

      @scheme = Scheme.find(params[:questionnaire][:scheme_id])
      @scheme.has_questionnaire  = true
      @scheme.save
        flash[:info] = "Questionnaire is saved."
        redirect_to request.referrer
    end
  end

  def copy
    @admin_schemes = Scheme.where(id: current_admin.scheme_ids, has_questionnaire: nil)

    @questionnaire = Questionnaire.find(params[:id])
    $copied_questionnaire = @questionnaire.dup
    $copied_questionnaire_questions =Question.where( questionnaire_id: params[:id])
    flash[:info] = "Questionnaire copied."
    render('copy')
  end

  def edit
    @questionnaire = Questionnaire.find(params[:id])
    render('edit')
  end


  def update
    @questionnaire = Questionnaire.find(params[:id])
      if @questionnaire.update(questionnaire_params)
          @questionnaire.save
          flash[:info] = "Questionnaire Updated."
          redirect_to questionnaires_path
      else
          render 'edit'
      end
  end


  def delete
    @questionnaire = Questionnaire.find(params[:id])
    render('delete')
  end

  def destroy
    @questionnaire = Questionnaire.find(params[:id])

    @questionnaire.destroy
    flash[:info] = "The questionnaire has been successfully deleted!"
    redirect_to(questionnaires_path)
  end


  private
    def questionnaire_params
      params.require(:questionnaire).permit( :name, :description, :scheme_id)
    end

    def check_questionnaire_exist
      unless Questionnaire.exists?(params[:id])
        redirect_to questionnaires_path
      end
    end

    def redirect_if_not_admin_or_coordinator
      unless admin_logged_in?
        if logged_in?
          unless EnrollIn.exists?(:role => "coordinator", :user_id => current_user.id)
            redirect_to user_profile_path
          end
        else
          redirect_to login_path
        end
      end
    end

    def redirect_if_not_assigned
      if admin_logged_in?
        case current_admin.scheme_access
        when "no schemes"
          redirect_to questionnaires_path
        when "assigned schemes"
          unless current_admin.scheme_ids.include?(Questionnaire.find(params[:id]).scheme_id)
            redirect_to questionnaires_path
          end
        when "assigned departments"
          unless current_admin.department_ids.include?(Questionnaire.find(params[:id]).scheme.department_id)
            redirect_to questionnaires_path
          end
        when "assigned departments and schemes"
          unless current_admin.scheme_ids.include?(Questionnaire.find(params[:id]).scheme_id)
            unless current_admin.department_ids.include?(Questionnaire.find(params[:id]).scheme.department_id)
              redirect_to questionnaires_path
            end
          end
        when "all schemes"
          return true
        end

      elsif logged_in?
        unless EnrollIn.exists?(:user_id => current_user.id, :scheme_id => Questionnaire.find(params[:id]).scheme_id)
          redirect_to questionnaires_path
        end
      end
    end

end
