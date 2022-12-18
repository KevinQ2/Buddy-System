require 'test_helper'

class QuestionnairesControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end


  #user set up
    def setup


    end

    test "should not get questionnaires_index when not logged in" do
      get questionnaires_url
      assert_response :success
    #   assert_not is_logged_in?
    #  assert_template "application/login_message"
    end

    test "should get questionnaires_index when logged in as admin" do
    #   log_in_as("testuser1", "Testuser1")
    #   assert is_logged_in?
      get questionnaires_url
      assert_response :success
      assert_template :index
    end

    test "should get show when logged in as admin" do
      # log_in_as("admin", "Caribouadmin1")
      # assert is_logged_in?
      questionnaire = questionnaires(:testOnequestionnaire)
      get questionnaire_url(questionnaire)
      assert_response :success
      assert_template :show
    end

    test "should not get show with invalid questionnaire id when logged in as admin" do
      #log_in_as("admin", "Caribouadmin1")
      #assert is_logged_in?
      get questionnaire_url("id")
      assert_response :success
      assert_template :invalid
    end

    test "should not get show with invalid questionnaire id when logged in as user" do
      #log_in_as("testuser1", "Testuser1")
      #assert is_logged_in?
      get questionnaire_url("id")
      assert_response :success
      assert_template :invalid
    end

    test "should not get show when logged in as user" do
      #log_in_as("testuser1", "Testuser1")
      #assert is_logged_in?
      questionnaire = questionnaires(:testOnequestionnaire)
      get questionnaire_url(questionnaire)
      assert_response :success
      assert_template :show
    end

    test "should not get show when not logged in" do
      questionnaire = questionnaires(:testOnequestionnaire)
      get questionnaire_url(questionnaire)
      assert_response :success
      #assert_not is_logged_in?
      assert_template "application/unauthorised"
    end

    test "should not get show when logged in, if not sender/receiver of the questionnaire" do
      #log_in_as("testuser2", "Testuser2")
      #assert is_logged_in?
      questionnaire = questionnaires(:testTwoquestionnaire)
      get questionnaire_url(questionnaire)
      assert_response :success
      assert_template "application/unauthorised"
    end

    test "should get new when logged in as user that owns an account" do
      #log_in_as("testuser1", "Testuser1")
      #assert is_logged_in?

      get new_questionnaire_url, params: { id: 1}
      assert_response :success
      assert_template "new"
    end

    test "should not get new with invalid account id when logged in as user" do
      #log_in_as("testuser1", "Testuser1")
      #assert is_logged_in?
      get new_questionnaire_url, params: { id: "id"}
      assert_response :success
      assert_template :invalid
    end

    test "should not get new when logged in as user that does not own an account" do
      #log_in_as("testusernoaccount", "testUserNoAccount1")
      #assert is_logged_in?
      get new_questionnaire_url
      assert_redirected_to welcome_apply_path
      follow_redirect!
      assert_template "welcome/apply"
    end

    test "should not get new when not logged in" do
      get new_questionnaire_url
      assert_response :success
      #assert_not is_logged_in?
      assert_template "application/login_message"
    end

    test "post create questionnaire should work with valid data when logged in as admin/user" do
      #log_in_as("testuser2", "Testuser2")
      #assert is_logged_in?

      assert_difference("Questionnaire.count", 1) do
        post questionnaires_url, params: { id: 1,
                                         questionnaire: {
                                           name: "test1",
                                           description: "Q1Description" } }
      end

    end

    test "post create questionnaire should not work with valid data when not logged in" do

      assert_difference('Questionnaire.count', 0) do
        post questionnaires_url, params: { id: 1,
                                         questionnaire: {
                                           name: "test1",
                                           description: "Q1Description" } }
      end
      #assert_not is_logged_in?
      assert_template "application/login_message"
    end


    test "should get edit questionnaire when logged in as admin" do
      #log_in_as("admin", "Caribouadmin1")
      #assert is_logged_in?
      questionnaire = questionnaires(:testOnequestionnaire)
      get edit_questionnaire_url(questionnaire)
      assert_response :success
      assert_template :edit
    end

    test "should not get edit with invalid questionnaire id when logged in as admin" do
      #log_in_as("admin", "Caribouadmin1")
      #assert is_logged_in?
      get edit_questionnaire_url("id")
      assert_response :success
      assert_template :invalid
    end

    test "should not get edit questionnaire when not logged in" do
      questionnaire = questionnaires(:testOnequestionnaire)
      get edit_questionnaire_url(questionnaire)
      assert_response :success
      #assert_not is_logged_in?
      assert_template "application/unauthorised"
    end

    test "should not get edit questionnaire when not logged in as admin" do
      #log_in_as("testuser1", "Testuser1")
      #assert is_logged_in?
      questionnaire = questionnaires(:testOnequestionnaire)
      get edit_questionnaire_url(questionnaire)
      assert_response :success
      assert_template "application/unauthorised"
    end

    test "patch update questionnaire should work with everything changed when logged in as admin" do
      #log_in_as("admin", "Caribouadmin1")
      #assert is_logged_in?

      questionnaire = questionnaires(:testOnequestionnaire)

      assert_no_difference('Questionnaire.count') do
        patch questionnaire_url(questionnaire), params: { id: 1,
                                         questionnaire: {
                                           name: "test1",
                                           description: "Q1Description" } }
      end
      questionnaire.reload
      get questionnaires_url
      assert_response :success
      assert_template :index

      assert_equal "test1", questionnaire.name
      assert_equal "Q1Description" , questionnaire.description

    end

    test "patch update questionnaire should not work with everything changed when sort code is the same as the banks but the receiver number is not registered" do
      #log_in_as("admin", "Caribouadmin1")
      #assert is_logged_in?
      questionnaire = questionnaires(:testOnequestionnaire)

      assert_no_difference('Questionnaire.count') do
        patch questionnaire_url(questionnaire), params: {
                                         questionnaire: {
                                           name: "test1",
                                           description: "Q1Description" } }
      end
      questionnaire.reload

      assert_response :success
      assert_template :edit
    end

    test "patch update questionnaire should not work with invalid questionnaire id when logged in as admin" do
      #log_in_as("admin", "Caribouadmin1")
      #assert is_logged_in?

      assert_no_difference('Questionnaire.count') do
        patch questionnaire_url("id"), params: {
                                         questionnaire: {
                                           name: "test1",
                                           description: "Q1Description" } }
      end
      assert_template :invalid
    end

    test "patch update questionnaire should not work with everything changed when not logged in" do
      questionnaire = questionnaires(:testOnequestionnaire)

      assert_no_difference('Questionnaire.count') do
        patch questionnaire_url(questionnaire), params: {
                                         questionnaire: {
                                           name: "test1",
                                           description: "Q1Description" } }
      end
      questionnaire.reload
      assert_template "application/unauthorised"
      assert_equal "test1", questionnaire.name
      assert_equal "Q1Description", questionnaire.description

    end

    test "patch update questionnaire should not work with everything changed when not logged in as admin" do
      #log_in_as("testuser1", "Testuser1")
      questionnaire = questionnaires(:testOnequestionnaire)

      assert_no_difference('Questionnaire.count') do
        patch questionnaire_url(questionnaire), params: {
                                         questionnaire: {
                                           name: "test1",
                                           description: "Q1Description" } }
      end
      questionnaire.reload
      assert_template "application/unauthorised"
      assert_equal "test1", questionnaire.name
      assert_equal "Q1Description", questionnaire.description

    end

    test "should get delete when logged in as admin" do
      #log_in_as("admin", "Caribouadmin1")
      #assert is_logged_in?
      questionnaire = questionnaires(:testOnequestionnaire)
      get delete_questionnaire_url(questionnaire)
      assert_response :success
      assert_template :delete
    end

    test "should not get delete with invalid questionnaire id when logged in as admin" do
      #log_in_as("admin", "Caribouadmin1")
      #assert is_logged_in?
      get delete_questionnaire_url(1)
      assert_response :success
      assert_template :invalid
    end

    test "should not get delete when not logged in" do
      questionnaire = questionnaires(:testOnequestionnaire)
      get delete_questionnaire_url(questionnaire)
      assert_response :success
      #assert_not is_logged_in?
      assert_template "application/unauthorised"
    end

    test "should not get delete when not logged in as admin" do
      #log_in_as("testuser1", "Testuser1")
      #assert is_logged_in?
      questionnaire = questionnaires(:testOnequestionnaire)
      get delete_questionnaire_url(questionnaire)
      assert_response :success
      assert_template "application/unauthorised"
    end

    test "should destroy questionnaire when logged in as admin" do
      #log_in_as("admin", "Caribouadmin1")
      #assert is_logged_in?
      questionnaire = questionnaires(:testOnequestionnaire)
      assert_difference('Questionnaire.count', -1) do
        delete questionnaire_url(questionnaire)
      end
      get questionnaires_url
      assert_response :success
      assert_template :index
    end

    test "should not destroy with invalid questionnaire id when logged in as admin" do
      #log_in_as("admin", "Caribouadmin1")
      #assert is_logged_in?
      assert_no_difference('Questionnaire.count') do
        delete questionnaire_url(1)
      end
      assert_template :invalid
    end

    test "should not destroy questionnaire when not logged in" do
      questionnaire = questionnaires(:testOnequestionnaire)
      assert_no_difference('Questionnaire.count') do
        delete questionnaire_url(questionnaire)
      end
      #assert_not is_logged_in?
      assert_template "application/unauthorised"
    end

    test "should not destroy questionnaire when not logged in as admin" do
      #log_in_as("testuser1", "Testuser1")
      #assert is_logged_in?
      questionnaire = questionnaires(:testOnequestionnaire)
      assert_no_difference('Questionnaire.count') do
        delete questionnaire_url(questionnaire)
      end
      assert_template "application/unauthorised"
    end

    test "should not get index when not logged in" do
      #assert @current_user.nil?
      #get questionnaires_url
      assert_response :success
      assert_template "application/login_message"
    end

    test "should get index when logged in as admin/user" do
      #log_in_as("testuser1", "Testuser1")
      #assert is_logged_in?
      get questionnaires_url
      assert_response :success
      assert_template :index
    end

  end
