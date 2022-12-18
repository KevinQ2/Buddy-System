require 'test_helper'

class QuestionsControllerTest < ActionDispatch::IntegrationTest


  test "should not get questions_index when not logged in" do
    get questions_url
    assert_response :success
  #   assert_not is_logged_in?
  #  assert_template "application/login_message"
  end

  test "should get questions_index when logged in as admin" do
  #   log_in_as("testuser1", "Testuser1")
  #   assert is_logged_in?
    get questions_url
    assert_response :success
    assert_template :index
  end

  test "should get show when logged in as admin" do
    # log_in_as("admin", "Caribouadmin1")
    # assert is_logged_in?
    question = questions(:testOnequestion)
    get question_url(question)
    assert_response :success
    assert_template :show
  end

  test "should not get show with invalid question id when logged in as admin" do
    #log_in_as("admin", "Caribouadmin1")
    #assert is_logged_in?
    get question_url("id")
    assert_response :success
    assert_template :invalid
  end

  test "should not get show with invalid question id when logged in as user" do
    #log_in_as("testuser1", "Testuser1")
    #assert is_logged_in?
    get question_url("id")
    assert_response :success
    assert_template :invalid
  end

  test "should not get show when logged in as user" do
    #log_in_as("testuser1", "Testuser1")
    #assert is_logged_in?
    question = questions(:testOnequestion)
    get question_url(question)
    assert_response :success
    assert_template :show
  end

  test "should not get show when not logged in" do
    question = questions(:testOnequestion)
    get question_url(question)
    assert_response :success
    #assert_not is_logged_in?
    assert_template "application/unauthorised"
  end

  test "should not get show when logged in, if not sender/receiver of the question" do
    #log_in_as("testuser2", "Testuser2")
    #assert is_logged_in?
    question = questions(:testTwoquestion)
    get question_url(question)
    assert_response :success
    assert_template "application/unauthorised"
  end

  test "should get new when logged in as user that owns an account" do
    #log_in_as("testuser1", "Testuser1")
    #assert is_logged_in?

    get new_question_url, params: { id: 1}
    assert_response :success
    assert_template "new"
  end

  test "should not get new with invalid account id when logged in as user" do
    #log_in_as("testuser1", "Testuser1")
    #assert is_logged_in?
    get new_question_url, params: { id: "id"}
    assert_response :success
    assert_template :invalid
  end

  test "should not get new when logged in as user that does not own an account" do
    #log_in_as("testusernoaccount", "testUserNoAccount1")
    #assert is_logged_in?
    get new_question_url
    assert_redirected_to welcome_apply_path
    follow_redirect!
    assert_template "welcome/apply"
  end

  test "should not get new when not logged in" do
    get new_question_url
    assert_response :success
    #assert_not is_logged_in?
    assert_template "application/login_message"
  end

  test "post create question should work with valid data when logged in as admin/user" do
    #log_in_as("testuser2", "Testuser2")
    #assert is_logged_in?

    assert_difference("question.count", 1) do
      post questions_url, params: { id: 1,
                                       question: {
                                         description: "test1",
                                         options: ["option1, option2"] }}
    end

  end

  test "post create question should not work with valid data when not logged in" do

    assert_difference('question.count', 0) do
      post questions_url, params: { id: 1,
                                       question: {
                                         description: "test1",
                                         options: ["option1, option2"] }}
    end
    #assert_not is_logged_in?
    assert_template "application/login_message"
  end


  test "should get edit question when logged in as admin" do
    #log_in_as("admin", "Caribouadmin1")
    #assert is_logged_in?
    question = questions(:testOnequestion)
    get edit_question_url(question)
    assert_response :success
    assert_template :edit
  end

  test "should not get edit with invalid question id when logged in as admin" do
    #log_in_as("admin", "Caribouadmin1")
    #assert is_logged_in?
    get edit_question_url("id")
    assert_response :success
    assert_template :invalid
  end

  test "should not get edit question when not logged in" do
    question = questions(:testOnequestion)
    get edit_question_url(question)
    assert_response :success
    #assert_not is_logged_in?
    assert_template "application/unauthorised"
  end

  test "should not get edit question when not logged in as admin" do
    #log_in_as("testuser1", "Testuser1")
    #assert is_logged_in?
    question = questions(:testOnequestion)
    get edit_question_url(question)
    assert_response :success
    assert_template "application/unauthorised"
  end

  test "patch update question should work with everything changed when logged in as admin" do
    #log_in_as("admin", "Caribouadmin1")
    #assert is_logged_in?

    question = questions(:testOnequestion)

    assert_no_difference('question.count') do
      patch question_url(question), params: { id: 1,
                                       question: {
                                         description: "test1",
                                         options: ["option1, option2"] }}
    end
    question.reload
    get questions_url
    assert_response :success
    assert_template :index

    assert_equal "test1", question.name
    assert_equal "Q1Description" , question.description

  end

  test "patch update question should not work with everything changed when sort code is the same as the banks but the receiver number is not registered" do
    #log_in_as("admin", "Caribouadmin1")
    #assert is_logged_in?
    question = questions(:testOnequestion)

    assert_no_difference('question.count') do
      patch question_url(question), params: {
                                       question: {
                                         description: "test1",
                                         options: ["option1, option2"] }}
    end
    question.reload

    assert_response :success
    assert_template :edit
  end

  test "patch update question should not work with invalid question id when logged in as admin" do
    #log_in_as("admin", "Caribouadmin1")
    #assert is_logged_in?

    assert_no_difference('question.count') do
      patch question_url("id"), params: {
                                       question: {
                                         description: "test1",
                                         options: ["option1, option2"] } }
    end
    assert_template :invalid
  end

  test "patch update question should not work with everything changed when not logged in" do
    question = questions(:testOnequestion)

    assert_no_difference('question.count') do
      patch question_url(question), params: {
                                       question: {
                                         description: "test1",
                                         options: ["option1, option2"] }}
    end
    question.reload
    assert_template "application/unauthorised"
    assert_equal "test1", question.name
    assert_equal "Q1Description", question.description

  end

  test "patch update question should not work with everything changed when not logged in as admin" do
    #log_in_as("testuser1", "Testuser1")
    question = questions(:testOnequestion)

    assert_no_difference('question.count') do
      patch question_url(question), params: {
                                       question: {
                                         description: "test1",
                                         options: ["option1, option2"] }}
    end
    question.reload
    assert_template "application/unauthorised"
    assert_equal "test1", question.name
    assert_equal "Q1Description", question.description

  end

  test "should get delete when logged in as admin" do
    #log_in_as("admin", "Caribouadmin1")
    #assert is_logged_in?
    question = questions(:testOnequestion)
    get delete_question_url(question)
    assert_response :success
    assert_template :delete
  end

  test "should not get delete with invalid question id when logged in as admin" do
    #log_in_as("admin", "Caribouadmin1")
    #assert is_logged_in?
    get delete_question_url(1)
    assert_response :success
    assert_template :invalid
  end

  test "should not get delete when not logged in" do
    question = questions(:testOnequestion)
    get delete_question_url(question)
    assert_response :success
    #assert_not is_logged_in?
    assert_template "application/unauthorised"
  end

  test "should not get delete when not logged in as admin" do
    #log_in_as("testuser1", "Testuser1")
    #assert is_logged_in?
    question = questions(:testOnequestion)
    get delete_question_url(question)
    assert_response :success
    assert_template "application/unauthorised"
  end

  test "should destroy question when logged in as admin" do
    #log_in_as("admin", "Caribouadmin1")
    #assert is_logged_in?
    question = questions(:testOnequestion)
    assert_difference('question.count', -1) do
      delete question_url(question)
    end
    get questions_url
    assert_response :success
    assert_template :index
  end

  test "should not destroy with invalid question id when logged in as admin" do
    #log_in_as("admin", "Caribouadmin1")
    #assert is_logged_in?
    assert_no_difference('question.count') do
      delete question_url(1)
    end
    assert_template :invalid
  end

  test "should not destroy question when not logged in" do
    question = questions(:testOnequestion)
    assert_no_difference('question.count') do
      delete question_url(question)
    end
    #assert_not is_logged_in?
    assert_template "application/unauthorised"
  end

  test "should not destroy question when not logged in as admin" do
    #log_in_as("testuser1", "Testuser1")
    #assert is_logged_in?
    question = questions(:testOnequestion)
    assert_no_difference('question.count') do
      delete question_url(question)
    end
    assert_template "application/unauthorised"
  end

  test "should not get index when not logged in" do
    #assert @current_user.nil?
    #get questions_url
    assert_response :success
    assert_template "application/login_message"
  end

  test "should get index when logged in as admin/user" do
    #log_in_as("testuser1", "Testuser1")
    #assert is_logged_in?
    get questions_url
    assert_response :success
    assert_template :index
  end

end
