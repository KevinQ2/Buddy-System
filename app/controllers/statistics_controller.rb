class StatisticsController < ApplicationController
  before_action :redirect_if_not_admin
  
  def index
    @schemes = Scheme.all
  end

  def show_questionnaires
    @questionnaires = Questionnaire.where(:scheme_id => params[:id])
  end

  def show_answers
    @questionnaire = Questionnaire.find(params[:id])
    @answers = []

    # set hash for each option in question
    @questionnaire.questions.each do |question|
      options = Hash.new(0)
      question.options.each do |option|
        options[option] = 0
      end

      @answers.push(options)
    end

    answers = Answer.where(:questionnaire_id => @questionnaire.id)

    answers.each do |answer|
      count = 0

      answer.user_answers.each do |individualAnswer|
        @answers[count][individualAnswer] += 1
        count += 1
      end
    end
  end
end
