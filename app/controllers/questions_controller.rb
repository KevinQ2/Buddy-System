class QuestionsController < ApplicationController
	before_action :check_question_exist, except: [:index, :new, :create]
	before_action :redirect_if_not_assigned, except: [:index, :new, :create]

	def index
		@questions = Question.order('id')
	end


  def show
    @question = Question.find(params[:id])
  end


	def new
	  @question = Question.new
 	end

  def edit
    @question = Question.find(params[:id])
  end

  def create
    # Inatantiate a question user using form parameters
    @question = Question.new(questions_params)

    # Save the questionnaire
    if @question.save
      # If save succeds, redirect to --
      redirect_to request.referrer, notice: "question is saved"
    else
      # If save fails, redisplay the form so can fix problems
      redirect_to request.referrer, notice: "Please try again, the question is not saved"
    end
  end

  def update
    # Find the relevant questionnaire
  @question = Question.find(params[:id])
	@questionnaire = Questionnaire.where( id: @question.questionnaire_id)
  if @question.update(questions_params)
    # If update passes redirect to show page
    redirect_to(questionnaires_path)
  else
      # If update fails stay on edit page
    render('edit')
  end
  end

  def delete
    @question = Question.find(params[:id])
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    redirect_to(questionnaires_path)
  end


	private

	def questions_params
    params.require(:question).permit(
			:description,
      :options,
      :match,
			:questionnaire_id,
			:give_priority,
			:matching_up_to_user

    )
  end

	def check_question_exist
		unless Question.exists?(params[:id])
			redirect_to questionnaires_path
		end
	end

	def redirect_if_not_assigned
		if current_admin.scheme_access == "all schemes"
			return true
		end

		scheme = Scheme.find(Questionnaire.find(Question.find(params[:id]).questionnaire_id).scheme_id)

		# redirect if current questionnaire page does not belong to a scheme permitted to the admin
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

		redirect_to questionnaires_path
	end

end
