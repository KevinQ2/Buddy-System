require 'test_helper'

class QuestionnaireTest < ActiveSupport::TestCase

  setup do
    @name = "name"
    @description = "description"
    @scheme = schemes(:one)
  end


  test "questionnaire with valid data" do
    questionnaire = Questionnaire.new(name: @name, description: @description, scheme: @scheme)
    assert questionnaire.valid?
  end

  test "questionnaire with invalid data, no name" do
    questionnaire = Questionnaire.new(description: @description, scheme: @scheme)
    assert !questionnaire.valid?
  end

  test "questionnaire with invalid data, no description" do
    questionnaire = Questionnaire.new(name: @name, scheme: @scheme)
    assert !questionnaire.valid?
  end

  test "questionnaire with invalid data, no scheme" do
    questionnaire = Questionnaire.new(name: @name, description: @description)
    assert questionnaire.valid?
  end


  test "questionnaire with invalid data, no data" do
    questionnaire = Questionnaire.new()
    assert !questionnaire.valid?
  end

end
