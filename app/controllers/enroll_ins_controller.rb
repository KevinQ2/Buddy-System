class EnrollInsController < ApplicationController

  # Check if requested URL scheme exists
  before_action :not_logged_return, only: [:new_mentee, :new_mentor]
  before_action :redirect_if_scheme_nonexisting
  before_action :redirect_if_user_enrolled_or_schema_ended, only: [:new_mentee, :new_mentor]

  def index
      @enroll_in = EnrollIn.all
  end

  def show
      @enroll_in = EnrollIn.find(params[:id])
  end

  def show_scheme_enrolled
      @scheme = Scheme.find(params[:scheme_id])
      @enroll_in = EnrollIn.where(scheme_id: params[:scheme_id])
  end

  def new_mentor
    if request.url == (EnrollLink.find_by(scheme_id: params[:scheme_id])).mentor_link
      @scheme = Scheme.find(params[:scheme_id])
      @answer = Answer.new
      @user_answer = Answer.find_by(scheme_id: params[:scheme_id], user_id: current_user.id )

      @url = session[:return_to]
      @enroll_in = EnrollIn.new
    else
      flash[:alert] = "Registration link is incorrect"
      redirect_to user_login_path
    end
  end

  def new_mentee
    if request.url == (EnrollLink.find_by(scheme_id: params[:scheme_id])).mentee_link
      @scheme = Scheme.find(params[:scheme_id])

      @answer = Answer.new
      @user_answer = Answer.find_by(scheme_id: params[:scheme_id], user_id: current_user.id )

      @url = session[:return_to]
      @enroll_in = EnrollIn.new
    else
      flash[:alert] = "Registration link is incorrect"
      redirect_to user_login_path
    end
  end

  def create_mentee
    @enroll_in = EnrollIn.new

    @enroll_in.scheme_id = params[:scheme_id]
    @enroll_in.role = "mentee"
    @enroll_in.user_id = current_user.id
    @enroll_in.matched = false

    @enroll_in.priority_score = 0
    @questionnaire = Questionnaire.find_by scheme_id: params[:scheme_id]
    @questionnaire_id = @questionnaire.id
    @questions = Question.where( questionnaire_id:@questionnaire_id )
    @questions.each do |question|
    @question_number = 0
      if question.give_priority == true
         @answers = Answer.where( questionnaire_id:@questionnaire_id, user_id: current_user.id )
         if @answers.first.user_answers[@question_number][0] == "True"
           @enroll_in.priority_score += 1
         end

         @question_number +=1

      end

    end

    if @enroll_in.save
      flash[:alert] = "You have successfully enrolled into the scheme"
      redirect_to users_path
    else
      flash[:alert] = @enroll_in.errors.full_messages.to_sentence
      redirect_to request.referrer
    end
  end

  def create_mentor
    @enroll_in = EnrollIn.new
    @enroll_in.scheme_id = params[:scheme_id]
    @enroll_in.user_id = current_user.id
    @enroll_in.role = "mentor"
    @enroll_in.matched = false
    @enroll_in.priority_score = 0
    @questionnaire = Questionnaire.find_by scheme_id: params[:scheme_id]
    @questionnaire_id = @questionnaire.id
    @questions = Question.where( questionnaire_id:@questionnaire_id )
    @questions.each do |question|
      @question_number = 0
      if question.give_priority == true
         @answers = Answer.where( questionnaire_id:@questionnaire_id, user_id: current_user.id )
         if @answers.first.user_answers[@question_number][0] == "True"
           @enroll_in.priority_score += 1
         end

         @question_number +=1

      end

    end

    @enroll_in.mentees_number = params[:enroll_in][:mentees_number]

    if @enroll_in.save
      flash[:alert] = "You have successfully enrolled into the schema"
      redirect_to users_path
    else
      flash[:alert] = @enroll_in.errors.full_messages.to_sentence
      redirect_to request.referrer
    end
  end


  def edit
      @enroll_in = EnrollIn.find(params[:id])
  end

  def update
      @enroll_in = EnrollIn.find(params[:id])
      if @enroll_in .update(answers_params)
      # If update passes redirect to show page
      redirect_to(enroll_in_path(@enroll_in))
      else
          # If update fails stay on edit page
          flash[:info] = "Please try again."
          render('edit')
      end
  end

  def delete
      @enroll_in = EnrollIn.find(params[:id])
  end

  def destroy
    @enroll_in = EnrollIn.find(params[:id])
    @enroll_in.destroy
    flash[:info] = "The Enrollment has been successfully deleted!"
    redirect_to(enroll_ins_path)
  end

  def enroll_ins_params
    params.require(:enroll_in).permit(
      :role,
      :user_id,
      :scheme_id,
      :matched,
      :mentees_number,
      :priority_score
    )
  end

  def not_logged_return
    unless logged_in?
      store_return_to
      redirect_to user_login_path
    end
  end
end
