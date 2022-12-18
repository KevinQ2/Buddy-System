require 'test_helper'

class InformationalPagesControllerTest < ActionDispatch::IntegrationTest
  
  
  test "should get existing public pages" do
    get informational_pages_path("about_project")
    assert_response :success
    get informational_pages_path("problem_solving")
    assert_response :success
    get informational_pages_path("terms_conditions")
    assert_response :success
  end

  test "should redirect to rooth path if page does not exist" do
    get informational_pages_path("test_page")
    assert_redirected_to root_path
  end

  test "should get welcome page" do
    get informational_pages_path("welcome_page")
    assert_response :success
  end


end
