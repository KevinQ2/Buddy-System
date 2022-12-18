class AnswersController < ApplicationController

  before_action :check_answers_exist, except: [:index, :new, :create]

  def index
		@answers = Answer.where(:user_id => current_user.id)
	end

  def show
    @answer = Answer.find(params[:id])
  end

	def new
	 @answer = Answer.new
 	end


  def edit_answers
    @answer = Answer.find(params[:id])
    $copied_answer = @answer.dup
    @questions = Question.where( questionnaire_id:  (Questionnaire.find_by scheme_id: @answer.scheme_id).id)
   render ("edit_answers")

  end

  def create

    # Inatantiate a answer user using form parameters

    @answer = Answer.new
    if params[:answer][:scheme_id] != ""
      @scheme_id  =params[:answer][:scheme_id]
    else
      @scheme_id = $copied_answer.scheme_id
      @answer_to_delete = Answer.where(scheme_id: @scheme_id, user_id: current_user.id ).first
      @answer_to_delete.destroy

    end
    @questionnaire = Questionnaire.find_by scheme_id:  @scheme_id
    @questionnaire_id = @questionnaire.id
    @answer.questionnaire_id = @questionnaire_id
    @answer.user_id =  current_user.id
    @answer.scheme_id =   @scheme_id
    @questions = Question.where( questionnaire_id:@questionnaire_id )
    @count = "1"
    @questions.each do |question|
        @count =  @count  + "1"
        @tag = "col"+ @count
        @array = []
        @array.append params[@tag]
        @match = "match_tag" + @count
        @array.append params[@match]
        @answer.user_answers.append @array

    end

    # Save the answernaire
    if @answer.save
      # If save succeds, redirect to the index action
      redirect_to request.referrer, notice: "Your answers are saved"
    else
      # If save fails, redisplay the form so can fix problems
      flash[:danger] = "Your answers were not saved"
      render("edit_answers")

    end
  end

  def update
    # Find the relevant answernaire
    @answer = Answer.find(params[:id])
    if @answer.update(answers_params)
      # If update passes redirect to show page
      flash[:info] = "Your answers got updated"
      redirect_to(answer_path(@answer))
    else
      # If update fails stay on edit page
      flash[:danger] =  "Try again"
      render('edit')
    end
  end

  def delete
    @answer = Answer.find(params[:id])
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy
    redirect_to(answers_path)
  end

	def answers_params
    params.require(:answer).permit(
			{user_answers: []},
      :user_id,
      :scheme_id,
      :questionnaire_id

    )
  end

  def check_answers_exist
    unless Answer.exists?(:id => params[:id], :user_id => current_user.id)
      redirect_to answers_path
    end
  end

end
