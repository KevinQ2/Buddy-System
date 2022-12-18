require 'test_helper'

class EnrollInControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "should not get coordinators_index when not logged in" do
    get coordinators_url
    assert_response :success
  #   assert_not is_logged_in?
  #  assert_template "application/login_message"
  end

  test "should get coordinators_index when logged in as admin" do
  #   log_in_as("testuser1", "Testuser1")
  #   assert is_logged_in?
    get coordinators_url
    assert_response :success
    assert_template :index
  end

  test "should get show_coordinator when logged in as admin" do
    # log_in_as("admin", "Caribouadmin1")
    # assert is_logged_in?
    coordinator = coordinators(:testOnecoordinator)
    get coordinator_url(coordinator)
    assert_response :success
    assert_template :show_coordiantor
  end

  test "should not get show_coordinator with invalid coordinator id when logged in as admin" do
    #log_in_as("admin", "Caribouadmin1")
    #assert is_logged_in?
    get coordinator_url("id")
    assert_response :success
    assert_template :invalid
  end

  test "should not get show_coordinator with invalid coordinator id when logged in as user" do
    #log_in_as("testuser1", "Testuser1")
    #assert is_logged_in?
    get coordinator_url("id")
    assert_response :success
    assert_template :invalid
  end

  test "should not get show_coordinator when logged in as user" do
    #log_in_as("testuser1", "Testuser1")
    #assert is_logged_in?
    coordinator = coordinators(:testOnecoordinator)
    get coordinator_url(coordinator)
    assert_response :success
    assert_template :show
  end

  test "should not get show_coordinator when not logged in" do
    coordinator = coordinators(:testOnecoordinator)
    get coordinator_url(coordinator)
    assert_response :success
    #assert_not is_logged_in?
    assert_template "application/unauthorised"
  end

  test "should not get new with invalid account id when logged in as user" do
    #log_in_as("testuser1", "Testuser1")
    #assert is_logged_in?
    get new_coordinator_url, params: { id: "id"}
    assert_response :success
    assert_template :invalid
  end

  test "should not get new when not logged in" do
    get new_coordinator_url
    assert_response :success
    #assert_not is_logged_in?
    assert_template "application/login_message"
  end

  test "post create coordinator should work with valid data when logged in as admin/user" do
    #log_in_as("testuser2", "Testuser2")
    #assert is_logged_in?

    assert_difference("Coordinator.count", 1) do
      post coordinators_url, params: { id: 1,
                                       coordinator: {
                                         role: "coordinator",
                                         user_id: 1,
                                         scheme_id: 1 } }
    end

    test "post create coordinator should not work with valid data when not logged in" do

      assert_difference('Coordinator.count', 0) do
        post coordinators_url, params: { id: 1,
                                         coordinator: {
                                           role: "description",
                                           user_id: 1,
                                           scheme_id: 1 } }
      end
      #assert_not is_logged_in?
      assert_template "application/login_message"
    end

  end

  test "should get delete when logged in as admin" do
    #log_in_as("admin", "Caribouadmin1")
    #assert is_logged_in?
    coordinator = coordinators(:testOnecoordinator)
    get delete_coordinator_url(coordinator)
    assert_response :success
    assert_template :delete
  end

  test "should not get delete with invalid coordinator id when logged in as admin" do
    #log_in_as("admin", "Caribouadmin1")
    #assert is_logged_in?
    get delete_coordinator_url(1)
    assert_response :success
    assert_template :invalid
  end

  test "should not get delete when not logged in" do
    coordinator = coordinators(:testOnecoordinator)
    get delete_coordinator_url(coordinator)
    assert_response :success
    #assert_not is_logged_in?
    assert_template "application/unauthorised"
  end

  test "should not get delete when not logged in as admin" do
    #log_in_as("testuser1", "Testuser1")
    #assert is_logged_in?
    coordinator = coordinators(:testOnecoordinator)
    get delete_coordinator_url(coordinator)
    assert_response :success
    assert_template "application/unauthorised"
  end

  test "should destroy coordinator when logged in as admin" do
    #log_in_as("admin", "Caribouadmin1")
    #assert is_logged_in?
    coordinator = coordinators(:testOnecoordinator)
    assert_difference('Coordinator.count', -1) do
      delete coordinator_url(coordinator)
    end
    get coordinators_url
    assert_response :success
    assert_template :index
  end

  test "should not destroy with invalid coordinator id when logged in as admin" do
    #log_in_as("admin", "Caribouadmin1")
    #assert is_logged_in?
    assert_no_difference('Coordinator.count') do
      delete coordinator_url(1)
    end
    assert_template :invalid
  end

  test "should not destroy coordinator when not logged in as admin" do
    #log_in_as("testuser1", "Testuser1")
    #assert is_logged_in?
    coordinator = coordinators(:testOnecoordinator)
    assert_no_difference('Coordinator.count') do
      delete coordinator_url(coordinator)
    end
    assert_template "application/unauthorised"
  end

  test "should not get index when not logged in" do
    #assert @current_user.nil?
    get coordinators_url
    assert_response :success
    assert_template "application/login_message"
  end

  test "should get index when logged in as admin/user" do
    #log_in_as("testuser1", "Testuser1")
    #assert is_logged_in?
    get coordinators_url
    assert_response :success
    assert_template :index
  end


end
