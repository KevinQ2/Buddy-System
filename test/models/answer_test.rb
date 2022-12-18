require 'test_helper'

class AnswerTest < ActiveSupport::TestCase

  setup do
    @questionnaire = questionnaires(:testTwoquestionnaire)
    @user = users(:one)
    @scheme = schemes(:one)
    @user_answers = ["1","2","3"]
  end


  test "answer with valid data" do
    answer = Answer.new(questionnaire_id: @questionnaire.id, user_id: @user.id, scheme_id: @scheme.id, user_answers: @user_answers)
    assert answer.valid?
  end

  test "answer with invalid data, no questionnaire" do
    answer = Answer.new(user_id: @user.id, scheme_id: @scheme.id, user_answers: @user_answers)
    assert !answer.valid?
  end

  test "answer with invalid data, no user" do
    answer = Answer.new(questionnaire_id: @questionnaire.id, scheme_id: @scheme.id, user_answers: @user_answers)
    assert !answer.valid?
  end

  test "answer with invalid data, no scheme" do
    answer = Answer.new(questionnaire_id: @questionnaire.id, user_id: @user.id, user_answers: @user_answers)
    assert !answer.valid?
  end

  test "answer with invalid data, no user_answers" do
    answer = Answer.new(questionnaire_id: @questionnaire.id, user_id: @user.id, scheme_id: @scheme.id)
    assert !answer.valid?
  end


  test "answer with invalid data, no data" do
    answer = Answer.new()
    assert !answer.valid?
  end

end
